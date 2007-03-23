Return-Path: <linux-kernel-owner+w=401wt.eu-S1751121AbXCWQVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751121AbXCWQVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 12:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXCWQVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 12:21:00 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4066 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121AbXCWQU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 12:20:59 -0400
Date: Fri, 23 Mar 2007 17:19:19 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>
Subject: Xorg fails to start on 2.6.21-rc4-git7
Message-Id: <20070323171919.7260a5b6.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

2.6.21-rc4-git7 doesn't work on my laptop, git6 was OK. Symptop: the
machine freezes as Xorg is started. A bisection led me there:

25496caec111481161e7f06bbfa12a533c43cc6f is first bad commit
commit 25496caec111481161e7f06bbfa12a533c43cc6f
Author: Thomas Renninger <trenn@suse.de>
Date:   Tue Feb 27 12:13:00 2007 -0500

    ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)
    
    Use IPI for blacklisted CPUs, add parameter IPI vs LAPIC
    
    Currently, Linux disables lapic timer for all machines with C2 and higher
    C-state support.
    
    According to Intel only specific Intel models (Banias/Dothan) are broken
    in respect of not waking up from C2 with lapic.
    
    However, I am not sure about the naming of the parameter and how it
    could/should get integrated into the dyntick part
    (CONFIG_GENERIC_CLOCKEVENTS). There, a more fine grained check (TSC
    still running?, ..) is needed? Does this make sense (always use
    CLOCK_EVT_NOTIFY_BROADCAST_ON, but use OFF if forced by use_ipi=0:
    clockevents_notify(use_ipi ? CLOCK_EVT_NOTIFY_BROADCAST_ON :
    CLOCK_EVT_NOTIFY_BROADCAST_OFF, &pr->id);
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 f089eab6ed1e602029c532d828e7d7a2e46e51af d639f8aa8676fee0bf0b868fe20151712f3a530c M      drivers

My laptop's CPU is:

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 11
model name	: Intel(R) Pentium(R) III Mobile CPU       866MHz
stepping	: 1
cpu MHz		: 864.500
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips	: 1724.04
clflush size	: 32

Thomas, Len, any idea? I can help with testing as needed.

-- 
Jean Delvare
