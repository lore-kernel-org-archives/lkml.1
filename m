Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXCRIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXCRIia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbXCRIia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:38:30 -0400
Received: from www.osadl.org ([213.239.205.134]:34543 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752318AbXCRIi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:38:29 -0400
Subject: Re: [PATCH] i386: trust the PM-Timer calibration of the local APIC
	timer
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@stusta.de>,
       Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <20070318001235.f388f551.akpm@linux-foundation.org>
References: <200703161230.03712.maximlevitsky@gmail.com>
	 <1174088686.13341.347.camel@localhost.localdomain>
	 <1174089896.13341.362.camel@localhost.localdomain>
	 <20070318001235.f388f551.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 09:45:26 +0100
Message-Id: <1174207526.13341.465.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 00:12 -0800, Andrew Morton wrote:
> On Sat, 17 Mar 2007 01:04:56 +0100 Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > When PM-Timer is available for local APIC timer calibration we can skip
> > the verification of the calibrated time value. The resulting error is
> > quite small on a bunch of evaluated platforms and is less harming than
> > the observed false positives.
> > 
> > We need to keep the verification on systems, which have no PM-Timer to
> > avoid bogus local APIC timer calibrations in the range of factor 2-10,
> > which can be observed when swicthing off the PM-timer support in the
> > kernel configuration.
> > 
> > The wrong calibration values are probably caused by SMM code trying to
> > emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard.
> > This prohibits the accurate delivery of PIT interrupts, which are used
> > to calibrate the local APIC timer. Unfortunately we have no way to
> > disable this BIOS misfeature in the early boot process.
> > 
> > Add also the dropped cpu_relax() back to the wait loops.
> 
> Is this a for-2.6.21 thing?

Yes please. The false positives of the original calibration are
annoying.

	tglx


