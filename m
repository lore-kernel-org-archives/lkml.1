Return-Path: <linux-kernel-owner+w=401wt.eu-S932925AbXJLJZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932925AbXJLJZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932824AbXJLJSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:18:30 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:59625 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600AbXJLJS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:18:27 -0400
Message-ID: <470F3BE0.4050807@free.fr>
Date: Fri, 12 Oct 2007 11:18:24 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: NMI watchdog
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm experiencing a full system lockup. I'm using an out-of-tree driver 
which I suspect is responsible. I'm trying to enable the NMI watchdog.

# cat /proc/version
Linux version 2.6.22.1-rt9 (gcc version 3.4.6) #1 PREEMPT RT Tue Oct 9 
12:25:47 CEST 2007

# cat /proc/cmdline
ro root=/dev/hdc1 console=ttyS0,57600n8 console=tty0 panic=3 apic=debug 
nmi_watchdog=2

However, after boot, the NMI count does not change.

# cat /proc/interrupts ; sleep 10 ; cat /proc/interrupts
            CPU0
   0:         99   IO-APIC-edge      timer
   4:       3822   IO-APIC-edge      serial
   8:          1   IO-APIC-edge      rtc
   9:          0   IO-APIC-fasteoi   acpi
  15:      16443   IO-APIC-edge      ide1
  16:       2166   IO-APIC-fasteoi   eth0
  17:        840   IO-APIC-fasteoi   eth1
  18:        840   IO-APIC-fasteoi   eth2
  19:        840   IO-APIC-fasteoi   eth3
  20:          0   IO-APIC-fasteoi   Dta1xx
  21:          0   IO-APIC-fasteoi   Dta1xx
NMI:       2895
LOC:     168445
ERR:          0
MIS:          0

            CPU0
   0:         99   IO-APIC-edge      timer
   4:       3822   IO-APIC-edge      serial
   8:          1   IO-APIC-edge      rtc
   9:          0   IO-APIC-fasteoi   acpi
  15:      16467   IO-APIC-edge      ide1
  16:       2173   IO-APIC-fasteoi   eth0
  17:        845   IO-APIC-fasteoi   eth1
  18:        845   IO-APIC-fasteoi   eth2
  19:        845   IO-APIC-fasteoi   eth3
  20:          0   IO-APIC-fasteoi   Dta1xx
  21:          0   IO-APIC-fasteoi   Dta1xx
NMI:       2895
LOC:     169448
ERR:          0
MIS:          0

Does this mean the NMI watchdog is not working correctly on my system?

# dmesg | grep NMI
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
Testing NMI watchdog ... OK.

Regards.
