Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbYBNQYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbYBNQYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYBNQY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:24:27 -0500
Received: from general.keba.net ([194.116.159.243]:39227 "EHLO keba.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758075AbYBNQYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:24:25 -0500
X-Greylist: delayed 2173 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2008 11:24:24 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [RT] Compile error with certain IRQ debug config option combinations
Date: Thu, 14 Feb 2008 16:48:05 +0100
Message-ID: <AAD6DA242BC63C488511C611BD51F367032B8BA5@MAILIT.keba.co.at>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RT] Compile error with certain IRQ debug config option combinations
Thread-Index: AchvIPze7PZ8lbsYTfqtwkMvGdfmxw==
From: "kus Kusche Klaus" <kus@keba.com>
To: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using 2.6.24.2 with -rt1 applied 
(applies cleanly with some offsets) on x86.

I've *not* configured PROVE_LOCKING (too expensive).
However, I selected all the latency tracings, timings and histograms,
among them CRITICAL_IRQSOFF_TIMING.
This implicitly configures TRACE_IRQFLAGS.
However, TRACE_IRQFLAGS depends on PROVE_LOCKING, which is off
(and not implicitly selected).

With TRACE_IRQFLAGS on and PROVE_LOCKING off,
compilation of kernel/lockdep.c fails miserably:
  CC      kernel/lockdep.o
kernel/lockdep.c: In function 'check_usage_forwards':
kernel/lockdep.c:1740: error: 'find_usage_bit' undeclared (first use in
this function)
kernel/lockdep.c:1740: error: (Each undeclared identifier is reported
only once
kernel/lockdep.c:1740: error: for each function it appears in.)
kernel/lockdep.c:1742: error: implicit declaration of function
'find_usage_forwards'
kernel/lockdep.c:1746: error: 'forwards_match' undeclared (first use in
this function)
kernel/lockdep.c: In function 'check_usage_backwards':
kernel/lockdep.c:1759: error: 'find_usage_bit' undeclared (first use in
this function)
kernel/lockdep.c:1761: error: implicit declaration of function
'find_usage_backwards'
kernel/lockdep.c:1765: error: 'backwards_match' undeclared (first use in
this function)
make[1]: *** [kernel/lockdep.o] Error 1

Looking at the source quickly, 
it seems that the #ifdefs do not cover that combination correctly, 
but I can't figure out how to fix that (the ifdef nesting in that file
seems to have grown over time...).


By the way: With all the tracing on, 
make also tries to compile scripts/trace-it.c (with HOSTCC),
which also fails if the kernel is cross-compiled in a non-linux
development environment 
(Interix in my case - don't ask me, I didn't vote for it...).

Many thanks in advance for any help!

Greetings

-- 
Klaus Kusche, DI. Dr.                    Software Development - Control
KEBA AG                        Gewerbepark Urfahr, A-4041 Linz, Austria
www.keba.com                         Firmenbuchgericht Linz FN 184376 t
mailto:kus@keba.com  Phone: +43 732 7090-23120  Fax: +43 732 7090-63401


