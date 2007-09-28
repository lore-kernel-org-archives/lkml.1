Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbXI1PK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbXI1PK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXI1PKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:10:20 -0400
Received: from www.osadl.org ([213.239.205.134]:51073 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752188AbXI1PKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:10:19 -0400
Subject: Re: [REGRESSION from 2.6.23-rc8]
From: Thomas Gleixner <tglx@linutronix.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <46FD18A5.9020907@redhat.com>
References: <200709231257.12213.rjw@sisk.pl>
	 <1190832665.23376.38.camel@chaos> <200709262149.54732.rjw@sisk.pl>
	 <200709262300.28336.rjw@sisk.pl> <1190842476.23376.57.camel@chaos>
	 <alpine.LFD.0.999.0709261521440.3579@woody.linux-foundation.org>
	 <1190846101.23376.64.camel@chaos>  <46FD18A5.9020907@redhat.com>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 17:10:16 +0200
Message-Id: <1190992216.18681.42.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 11:07 -0400, Chuck Ebbert wrote:
> On 09/26/2007 06:35 PM, Thomas Gleixner wrote:
> > It's even worse than I thought on the first check:
> > 
> > "noapictimer" on the command line of an SMP box prevents _ONLY_ the boot
> > CPU apic timer from being used. But the secondary CPU is still
> > unconditionally setting up the APIC timer and uses the non calibrated
> > variable calibration_result, which is of course 0, to setup the APIC
> > timer. Wreckage guaranteed.
> > 
> 
> Is this why I get 1000 spurious interrupts/second on IRQ7 when booting
> x86_64 with "noapic"?

No, thats a different problem. The wreckage is a stuck local apic timer
interrupt.

	tglx


