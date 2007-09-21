Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbXIUJNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbXIUJNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXIUJM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:12:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42141 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbXIUJM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:12:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when booted, USB-related WARNING
Date: Fri, 21 Sep 2007 11:25:56 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <200709201935.04400.lenb@kernel.org> <1190361361.3085.103.camel@chaos>
In-Reply-To: <1190361361.3085.103.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709211125.58095.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 September 2007 09:56, Thomas Gleixner wrote:
> On Thu, 2007-09-20 at 19:35 -0400, Len Brown wrote:
> > > > (Btw, the above commit message points to just my response with a testing 
> > > > patch to the real email: the actual explanation of the INSANE ordering is 
> > > > from Len Brown in
> > > > 
> > > > 	https://lists.linux-foundation.org/pipermail/linux-pm/2006-November/004161.html
> > > > 
> > > > and there Len claims that we *must* wake up CPU's early).
> > > 
> > > ..and points to commit 1a38416cea8ac801ae8f261074721f35317613dc which in 
> > > turn talks about http://bugzilla.kernel.org/show_bug.cgi?id=5651 
> > > 
> > > Howerver, it seems that bugzilla entry may just be bogus. It talks about 
> > > "it appears that some firmware in the future may depend on that sequence 
> > > for correction operation"
> > > 
> > > Len, Shaohua, what are the real issues here? 
> > 
> > Intel's reference BIOS for Core Duo performs some re-initialization
> > in _WAK that will get blow away if INIT follows _WAK.
> > IIR, it is related to re-initializing the thermal sensors.
> > I opened bug 5651 when the BIOS team informed me of this issue.
> > 
> > Yes, bringing a processor offline and then online again w/o
> > an intervening suspend or reset would not evaluate _WAK,
> > and thus may still run into the issue.
> 
> If this is true, then we should disable the sys/..../cpu/online entry
> right away.

Or drop the execution of _INI from the CPU hotplug, if possible ...

Greetings,
Rafael
