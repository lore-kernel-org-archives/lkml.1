Return-Path: <linux-kernel-owner+w=401wt.eu-S935693AbYD1Piv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935693AbYD1Piv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934088AbYD1Pim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:38:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934031AbYD1Pil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:38:41 -0400
Date: Mon, 28 Apr 2008 17:38:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [git pull] "big box" x86 changes, PCI
Message-ID: <20080428153817.GF18776@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426215540.GA3545@elte.hu> <200804270930.55647.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804270930.55647.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Saturday, April 26, 2008 2:55 pm Ingo Molnar wrote:
> > ok, this is the final chunk of the "big box" topic - the PCI changes.
> >
> > These are the largest, and while i tried to reduce their number it's
> > still 19 commits - but it's all around the same topic. The bulk of the
> > new code is in a single file. The tree can be pulled from:
> >
> >   
> > git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-bigbox-pci.
> >git for-linus
> >
> > this depends on the bootmem changes which are now upstream. These
> > changes too have been in linux-next for some time and the cross-arch
> > (build) success rate is high, as in:
> >
> >    http://www.tglx.de/autoqa-cgi/index?run=89&tree=1
> >
> > all but the last few patches have been in x86.git for a longer time and
> > more than 95% of the changes are for arch/x86. (see the dates of the
> > patches. The "15 Feb 2008" ones are older than their timestamp - that's
> > when we imported those changes into a date-aware repository.)
> >
> > i booted up this tree 5 times on x86, mixed 64-bit/32-bit.
> 
> Only did a quick scan, but the changes look nice so far.  I'll take a 
> closer look and give it a try locally tomorrow.

ok, great! Let us know if you experience any problems - and please give 
us an Ack if it looks OK so that we can send the final pull request to 
Linus :-)

> On an unrelated note, can you take a look at the "PCI MSI breaks when 
> booting with nosmp" thread?  I posted a patch there that 
> unconditionally enables the local apic with nosmp/maxcpus=0 so that 
> MSI will work correctly.  The other option of course is to disable MSI 
> when nosmp/maxcpus=0 and local apic enable code alone.

yeah - great fix - your patch has been put into x86.git a few minutes 
after you posted the fix ;-) I think that's been a long-standing problem 
(== was broken forever), i noticed it happen on a number of Intel SDV 
boards myself in the past and initially suspected e1000 - it is the 
first driver that throws a fit with non-working MSI interrupts.

I never managed to track it down (there was nothing to bisect to and far 
enough in the past kernels simply stopped booting on that hardware) and 
things like acpi=off regularly dont work on prototype boards anyway. I'm 
glad you figured it out and it's on the way upstream.

	Ingo
