Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbZEMK11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbZEMK11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbZEMK1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:27:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:5425 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbZEMK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=ZPJCukZ0F2bIhwt0TfQdVA4nJ0lt+6XfEQ7MJNhn7rCVTkqNTYr50ZzA3N7beXDf3i
         spuoYVL/XSfQ8DFND3u0mEUGzqUvA5uPySVF9s5PddmqPCctoznEA9slmm4n2zvyGxzM
         vD98sydy4tpZGGZt2kLqFBSlgOnfdh3OzCpKc=
Date: Wed, 13 May 2009 19:27:16 +0900
From: "qmh524" <qmh524@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: timer interrupt handled by CPU0 only
Message-ID: <200905131927152180665@gmail.com>
X-mailer: Foxmail 6, 14, 103, 30 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have start irqbalance service. Why the timer interrupt only happend in CPU0
$ sudo service irqbalance status
irqbalance (pid 2390) is running...
$ cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:   21487296          0          0          0    IO-APIC-edge  timer
  1:          3          0          0          0    IO-APIC-edge  i8042
  8:          1          0          0          0    IO-APIC-edge  rtc
  9:          0          0          0          0   IO-APIC-level  acpi
 12:          4          0          0          0    IO-APIC-edge  i8042
 74:         18          0          0          0   IO-APIC-level
uhci_hcd:usb1, uhci_hcd:usb3, ehci_hcd:usb4
 82:          0          0          0          0   IO-APIC-level  uhci_hcd:usb2
 90:       1934          0   45886283          0   IO-APIC-level  libata
 98:          0          0          0          0   IO-APIC-level  libata
106:        120          0          0   22824923         PCI-MSI  eth0
169:      16933          0    9370507          0   IO-APIC-level  ioc0
NMI:      43241      26776      33934      29946
LOC:   21487192   21487118   21487046   21486887
ERR:          0
MIS:          0
$ uname -a
Linux xxx 2.6.18-53.el5 #1 SMP Mon Nov 12 02:14:55 EST 2007 x86_64
x86_64 x86_64 GNU/Linux
$ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           L5410  @ 2.33GHz
stepping	: 6
cpu MHz		: 2333.339
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm
constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips	: 4669.93
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           L5410  @ 2.33GHz
stepping	: 6
cpu MHz		: 2333.339
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm
constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips	: 4666.62
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           L5410  @ 2.33GHz
stepping	: 6
cpu MHz		: 2333.339
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm
constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips	: 4666.69
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Xeon(R) CPU           L5410  @ 2.33GHz
stepping	: 6
cpu MHz		: 2333.339
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm
constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr lahf_lm
bogomips	: 4666.54
clflush size	: 64
cache_alignment	: 64
address sizes	: 38 bits physical, 48 bits virtual
power management:

$

