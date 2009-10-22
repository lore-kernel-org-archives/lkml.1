Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbZJVXKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbZJVXKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 19:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZJVXKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 19:10:53 -0400
Received: from outbound-mail-308.bluehost.com ([67.222.53.254]:36705 "HELO
	outbound-mail-308.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755199AbZJVXKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 19:10:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hUd0ut9iqCarrmpcrRija3sCFIxtxoU7GGB8A5Gyn3bdHSuoD/zjODsrUNPRScWdYTYSO09PnFpvIlRltENmKqfVASZGD7ZvifCdKtllINkGLrddrgn97nVf1WPw7Phs;
Date: Fri, 23 Oct 2009 08:10:47 +0900
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric Anholt <eric@anholt.net>,
       Thomas Schlichter <thomas.schlichter@web.de>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <JBeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
Message-ID: <20091023081047.4d8abc29@jbarnes-x200>
In-Reply-To: <1256248050.2546.9.camel@sbs-t61>
References: <1394846127@web.de>
	<4ADF32A0020000780001B20A@vpn.id2.novell.com>
	<20091021173514.GA32227@elte.hu>
	<200910212201.36578.thomas.schlichter@web.de>
	<1256205210.2530.28.camel@sbs-t61>
	<1256225689.32075.6.camel@gaiman.anholt.net>
	<1256248050.2546.9.camel@sbs-t61>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 125.200.72.71 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009 14:47:30 -0700
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> On Thu, 2009-10-22 at 08:34 -0700, Eric Anholt wrote:
> > Can we just not create the _wc sysfs entry if we don't have PAT?  I
> > don't think there's userland relying on its presence as opposed to
> > the non-_wc entry.
> 
> Yes indeed. Jesse do you see an issue with this? This is simple and
> clean. Thanks Eric.

Yeah, I think that will be fine.  In fact, older versions of
libpciaccess will behave better if we do it that way (iirc it only
allocates an MTRR if the resource_wc file doesn't exist or fails to get
mapped).

Jesse
