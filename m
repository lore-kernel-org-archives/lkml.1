Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbYLPUxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbYLPUxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLPUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:52:54 -0500
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:48433 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751699AbYLPUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:52:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=H+5IPZQ7jB1OttZ30j9KA8y5ANrtHjDdFOlWa5KipFUYl+yV75+A/dvS0aawxGDDalonYmMkmbXztH+y4Z3tc90H+SPqXho87xDetCYLV7PyfjSMGzF57edcTii/apwU;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] ibmphp: Fix module ref count underflow
Date: Tue, 16 Dec 2008 12:52:50 -0800
User-Agent: KMail/1.10.1 (Linux/2.6.27.5-41.fc9.x86_64; KDE/4.1.3; x86_64; ; )
Cc: greg@kroah.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <20081210194334.GA25257@hmsreliant.think-freely.org> <200812161042.09345.jbarnes@virtuousgeek.org> <20081216195620.GA10231@hmsreliant.think-freely.org>
In-Reply-To: <20081216195620.GA10231@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812161252.51191.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 16, 2008 11:56 am Neil Horman wrote:
> On Tue, Dec 16, 2008 at 10:42:08AM -0800, Jesse Barnes wrote:
> > On Wednesday, December 10, 2008 11:43 am Neil Horman wrote:
> > > Hey-
> > > 	I happened to notice that the ibmphp hotplug driver does something
> > > rather silly in its init routine.  It purposely calls module_put so as
> > > to underflow its module ref count to avoid being removed from the
> > > kernel. This is bad practice, and wrong, since it provides a window for
> > > subsequent module_gets to reset the refcount to zero, allowing an
> > > unload to race in and cause all sorts of mysterious panics.  If the
> > > module is unsafe to load, it should inform the kernel as such with a
> > > call to __unsafe.  The patch below does that.
> >
> > Thanks Neil, applied this to my for-linus branch since it sounds
> > potentially serious (but also low risk since who uses ibmphp anymore? :)
>
> Dang it!  Sorry, Jesse.  Yes, youre absolutely right, it is low risk.  It
> really just a bit of sillyness all around.
>
> Unfortunately, I took part in the sillyness.  The problem was reported to
> me on RHEL, and I tested there, without checking upstream too closely.  As 
> aresult, the patch I gave you is a bit out of date, and won't compile. 
> I've tested the new patch here much more closely.  apologies.  I informed
> akpm who was looking at it, but neglected to copy you.
>
> This patch corrects the same problem in that it prevents module unloads in
> a sane fashion, by not registering an exit routine
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Ah was just doing my testing & building now so I would have caught it in a 
minute. :)  I'll replace the patch I have with this one, thanks.

Jesse
