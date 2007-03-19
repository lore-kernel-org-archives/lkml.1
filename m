Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbXCSTUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbXCSTUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 15:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbXCSTUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 15:20:54 -0400
Received: from www.osadl.org ([213.239.205.134]:60748 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752444AbXCSTUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 15:20:53 -0400
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stefan Prechtel <stefan.prechtel@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@suse.de>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com>
	 <1174325803.13341.515.camel@localhost.localdomain>
	 <1174326499.13341.517.camel@localhost.localdomain>
	 <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 20:27:56 +0100
Message-Id: <1174332477.13341.561.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

On Mon, 2007-03-19 at 19:53 +0100, Stefan Prechtel wrote:
> You can find the files here:
> http://bugzilla.kernel.org/show_bug.cgi?id=8235

thanks for providing the data. Your ACPI tables don't provide
information about the power states (C-States), but your BIOS seems to
switch the CPUs into deeper power states, when it runs on battery. In
those deeper power states the local APIC timers and the TSC are stopped.
So the machine waits for ever on the next timer interrupt.

We have a broadcast mechanism for this, which gets activated from ACPI,
but the broadcast mechanism is not activated:

[    3.798000] Clock Event Device: pit
....
[    3.798000] tick_broadcast_mask: 00000000

Can you please boot with 2.6.20 or earlier and check the output
of /proc/interrupts ?

IRQ#0 and the LOC (local APIC timer) Interrupts should increment in the
same frequency.

	tglx


