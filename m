Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbZALRya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbZALRya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:54:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZALRxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:53:54 -0500
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:46677 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752620AbZALRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:53:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=YunlugYoQPCBfAcHtkGLsROLVfxXGCBRY2O4IKfnNOafx6AXJMjfqQ2PoU1XIYsKJ3np1n8XmtFjiZhi0KWQ6pdcPrCIPkKQzl1Q2xAIwBAIRV/idJMEcXXf+Jp0SXky;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Date: Mon, 12 Jan 2009 09:53:49 -0800
User-Agent: KMail/1.9.10
Cc: Dave Airlie <airlied@gmail.com>, Jan Dittmer <jdi@l4x.org>,
       Diego Calleja <diegocg@gmail.com>, linux-kernel@vger.kernel.org,
       eric.anholt@iintel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <21d7e9970901120004t2dd68241x6b9533f489601109@mail.gmail.com> <20090112130343.GA89729@dspnet.fr.eu.org>
In-Reply-To: <20090112130343.GA89729@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901120953.50167.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2009 5:03 am Olivier Galibert wrote:
> On Mon, Jan 12, 2009 at 06:04:19PM +1000, Dave Airlie wrote:
> > explicit VideoRAM is most likely ignored by xorg as well for Intel
> > chipsets with the latest driver,
>
> I'm going on a tangeant, but it would be nice if video drivers, intel
> first among them, would stop ignoring user-provided configurations in
> favour of firmwares, bioses, in-display roms and other things like
> that that can be incorrect and not user-modifiable.  VideoRAM is one,
> but there's also modeline, DPI...

On the contrary, I think we have way too many options and configuration 
possibilities.  The more we have, the more likely some combination of them 
will be broken.

That said, modes are generally pretty easy to handle, so users can provide 
them through xrandr and xorg.conf; I don't see that changing.  VideoRAM OTOH 
was broken by design.  A user really has no way of knowing how much memory is 
available to the GPU, so providing a configurable value was causing way more 
problems than it solved.

But I suspect what you want it something else entirely, like a limit on the 
amount of RAM that will be used by the GPU.  I think that's a valid concern 
and something like that could probably be added to GEM w/o too much trouble, 
maybe through a new ulimit or system wide tunable.

-- 
Jesse Barnes, Intel Open Source Technology Center
