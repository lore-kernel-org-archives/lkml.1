Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXIUH4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXIUH4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 03:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXIUH4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 03:56:05 -0400
Received: from www.osadl.org ([213.239.205.134]:42640 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750856AbXIUH4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 03:56:04 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, miklos@szeredi.hu,
       Len Brown <len.brown@intel.com>,
       David Shaohua Li <shaohua.li@intel.com>
In-Reply-To: <200709201935.04400.lenb@kernel.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0709201420231.16478@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0709201437310.16478@woody.linux-foundation.org>
	 <200709201935.04400.lenb@kernel.org>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 09:56:01 +0200
Message-Id: <1190361361.3085.103.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 19:35 -0400, Len Brown wrote:
> > > (Btw, the above commit message points to just my response with a testing 
> > > patch to the real email: the actual explanation of the INSANE ordering is 
> > > from Len Brown in
> > > 
> > > 	https://lists.linux-foundation.org/pipermail/linux-pm/2006-November/004161.html
> > > 
> > > and there Len claims that we *must* wake up CPU's early).
> > 
> > ..and points to commit 1a38416cea8ac801ae8f261074721f35317613dc which in 
> > turn talks about http://bugzilla.kernel.org/show_bug.cgi?id=5651 
> > 
> > Howerver, it seems that bugzilla entry may just be bogus. It talks about 
> > "it appears that some firmware in the future may depend on that sequence 
> > for correction operation"
> > 
> > Len, Shaohua, what are the real issues here? 
> 
> Intel's reference BIOS for Core Duo performs some re-initialization
> in _WAK that will get blow away if INIT follows _WAK.
> IIR, it is related to re-initializing the thermal sensors.
> I opened bug 5651 when the BIOS team informed me of this issue.
> 
> Yes, bringing a processor offline and then online again w/o
> an intervening suspend or reset would not evaluate _WAK,
> and thus may still run into the issue.

If this is true, then we should disable the sys/..../cpu/online entry
right away.

	tglx


