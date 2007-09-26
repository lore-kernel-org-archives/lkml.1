Return-Path: <linux-kernel-owner+w=401wt.eu-S1763076AbXIZWfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763076AbXIZWfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbXIZWfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:35:06 -0400
Received: from www.osadl.org ([213.239.205.134]:34279 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751025AbXIZWfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:35:04 -0400
Subject: Re: [REGRESSION from 2.6.23-rc8] (was: Re: 2.6.23-rc4-mm1 and
	-rc6-mm1: boot failure on HP nx6325, related to clockevents)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org>
References: <200709231257.12213.rjw@sisk.pl>
	 <1190832665.23376.38.camel@chaos> <200709262149.54732.rjw@sisk.pl>
	 <200709262300.28336.rjw@sisk.pl> <1190842476.23376.57.camel@chaos>
	 <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 00:35:01 +0200
Message-Id: <1190846101.23376.64.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 15:22 -0700, Linus Torvalds wrote:
> 
> On Wed, 26 Sep 2007, Thomas Gleixner wrote:
> > > 
> > > 1) current Linus' tree doesn't boot with any command line (regression)
> > > 
> > > [  Linus, please revert commit e66485d747505e9d960b864fc6c37f8b2afafaf0
> 
> Reverted.
> 
> > OK, this explains 2) and 3). I just looked into the code and the logic
> > vs. noapictimer on SMP is completely broken.
> 
> ..and thanks for the explanation.
> 
> Thanks for finding it so quickly guys. Sounds like this will be fixed 
> properly in 2.6.24 with the x86 merge (which hopefully brings in the hrt 
> patch too)

It's even worse than I thought on the first check:

"noapictimer" on the command line of an SMP box prevents _ONLY_ the boot
CPU apic timer from being used. But the secondary CPU is still
unconditionally setting up the APIC timer and uses the non calibrated
variable calibration_result, which is of course 0, to setup the APIC
timer. Wreckage guaranteed.

	tglx


