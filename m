Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbXCDShe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbXCDShe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 13:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXCDShe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 13:37:34 -0500
Received: from nn7.de ([85.214.94.156]:53441 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbXCDShd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 13:37:33 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2007 13:37:33 EST
Subject: macbook pro suspend to ram broken in linux-2.6.git HEAD
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Mar 2007 19:30:49 +0100
Message-Id: <1173033049.4094.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

a rather long git bisect session between v2.6.20 and HEAD identified the
commit below this as the cause. please note that the machine does not
return from resume and although all PM debug was turned on there is
nothing in the logs. happens with a minimalistic setup (console only no
audio/network etc) without SMP and CONFIG_HPET_TIMER  but PREEMPT on and
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y

Any ideas on that issue ?
Soeren

e9e2cdb412412326c4827fc78ba27f410d837e6e is first bad commit
commit e9e2cdb412412326c4827fc78ba27f410d837e6e
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Fri Feb 16 01:28:04 2007 -0800

    [PATCH] clockevents: i386 drivers
    
    Add clockevent drivers for i386: lapic (local) and PIT/HPET (global).  Update
    the timer IRQ to call into the PIT/HPET driver's event handler and the
    lapic-timer IRQ to call into the lapic clockevent driver.  The assignement of
    timer functionality is delegated to the core framework code and replaces the
    compile and runtime evalution in do_timer_interrupt_hook()
    
    Use the clockevents broadcast support and implement the lapic_broadcast
    function for ACPI.
    
    No changes to existing functionality.
    
    [ kdump fix from Vivek Goyal <vgoyal@in.ibm.com> ]
    [ fixes based on review feedback from Arjan van de Ven <arjan@infradead.org> ]
    Cleanups-from: Adrian Bunk <bunk@stusta.de>
    Build-fixes-from: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Cc: john stultz <johnstul@us.ibm.com>
    Cc: Roman Zippel <zippel@linux-m68k.org>
    Cc: Andi Kleen <ak@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 8cd88ef4dc6e976c589deda1c558e19ed8dcafde 88ed93cefb145aa545ff4561636cc9342fc7bb42 M      arch
:040000 040000 5a1342027bc77019bb3ca9295d02bf483410e3d4 3de4aedc5bb5d86287b7a5bad4b673e8ffbc1e44 M      drivers
:040000 040000 88ade982261c3ce0590c939694994796f02d2e73 d7221468ac776ccc7804f9a46d6d53fa7c294d43 M      include

-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
