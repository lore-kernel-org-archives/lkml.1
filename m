Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYICTHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYICTHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYICTGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:06:44 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:45839 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbYICTGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:06:43 -0400
Date: Wed, 3 Sep 2008 16:07:05 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Nezhevenko <dion@inhex.net>, herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903160705.0efd7308@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902175544.131bc54e@doriath.conectiva>
	<alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
	<20080903104132.7a736282@doriath.conectiva>
	<alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
	<20080903164415.GA24442@laptop.local>
	<alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
	<20080903143653.68bb58df@doriath.conectiva>
	<alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 3 Sep 2008 20:40:55 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| >  As the dmesg has various WARN_ON() outputs I'm attaching it, this is
| > the first one:
| > 
| > """
| > PCI: Using ACPI for IRQ routing
| > DMAR:parse DMAR table failure.
| > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
| > hpet0: 3 32-bit timers, 25000000 Hz
| > Switched to high resolution mode on CPU 0
| >
| > tick_broadcast_set_event is stuck f09fa64 f0a01e4
| 
| Hmm, so we fail to force program that HPET with the standard minimum
| delta.
| 
| I now see why this is happening and it is happening only on systems
| with a fast HPET. Your's running 25MHz, so the delta is only 1.92
| usec. I was staring at lots of those bugreports without noticing the
| frequency.
| 
| Sigh. The idea to take a fixed number of HPET cycles as the minimum
| was not really brilliant it seems.
| 
| Does the patch below help ? Keep the debug patch applied, as we can
| see whether the check triggers or not.

 Yeah, it works. I have booted three times with no warnings.

 I will revert the debug patch and test again just to be sure, if
this is of any help:

Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>

 By the way, is this the definitive fix?

-- 
Luiz Fernando N. Capitulino
