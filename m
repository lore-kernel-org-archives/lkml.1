Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZFCEzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZFCEzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbZFCEzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:55:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:13325 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZFCEzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:55:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Lj0pCSJNY5uHWollNLb9jDjZlei7Jp+PRRQWeHHxCYb5bWhPTyOvAoM/SC+BLHG2xD
         AKJ6I8VduDN/NED6D2xa5e0EP4BbcGqW6Gqe5gZATb+I/4//XJ15rVxONwQZ9N1KwAF3
         oYdP8HL79J1x5hbsIslvvRkVlowrfWcRtmf0o=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0905251545520.3582@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0905251545520.3582@localhost.localdomain>
Date: Wed, 3 Jun 2009 13:55:07 +0900
Message-ID: <49b7c2350906022155u542b6345xad5859382376d55@mail.gmail.com>
Subject: Re: 2.6.29.4-rt16
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 10:47 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.4.tar.bz2
>    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29.4-rt16.bz2

Thank you for notice of 2.6.29.r-rt16 release.

This is a report  about "/proc/interrupts" result in my development system.

* System requirements :
  Core2 Quad Q6600 , LV-676 Motherboard , SATA 160G, DDR2 3G ,
  ftp://ftp.commell.com.tw/COMMELL/support/LV-676/BIOS/676x161.zip.

In summary, I can't get irq loadbalancing(/proc/interrupts) in my system using
2.6.29.4-rt16 linux kernel because of LV-676 motherboard's  H/W problem.
( I disabled [ ]irqbalance - userspace with "ntsysv" command in this
experiment . )


[geunsik@centos5.3 ~]$
[geunsik@centos5.3 ~]$
[geunsik@centos5.3 ~]$ cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3
  0:        136          0          0          0   IO-APIC-edge      timer
  1:          2          0          0          0   IO-APIC-edge      i8042
  3:          2          0          0          0   IO-APIC-edge
  4:          2          0          0          0   IO-APIC-edge
  6:          2          0          0          0   IO-APIC-edge      floppy
  7:          0          0          0          0   IO-APIC-edge      lpptest
  8:          1          0          0          0   IO-APIC-edge      rtc
  9:          1          0          0          0   IO-APIC-fasteoi   acpi
 16:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb3
 18:      15030       2133       4521          0   IO-APIC-fasteoi
libata, libata, uhci_hcd:usb6
 19:       1133          0          0          0   IO-APIC-fasteoi
ehci_hcd:usb1, uhci_hcd:usb7
 20:          3          0          0          0   IO-APIC-fasteoi
ehci_hcd:usb2, uhci_hcd:usb5
 21:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb4
223:        871          0          0          0   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     158448     161871     160140     161074   Local timer interrupts
RES:        735        822       1378       1028   Rescheduling interrupts
CAL:       3397       3408       1948       2452   function call interrupts
TLB:        240        288        266        310   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          0
MIS:          0
[geunsik@centos5.3 ~]$

So, I asked Commell company about this problems.
For reference, Belows is answer from their technical service team.

-- [ From tech@commell.com.tw] ---------------------------------------------
Hi
Sorry for keep you waiting.
We had setn LV-676 motherboard to BIOS vendor for solution,
still now no resond yet, any respond will pass to you.

We had constantly push for solution, and BIOS vendor is working on this
issue and attempt to solve this problem,
any message from them will let you know.
BR
K.H. Ooi
------------------------------------------------------------------------------------

Currently, I am using "smp_affinity" in this LV-676 mother board like belows.

          Binary Hex
    CPU 0 0001 1
    CPU 1 0010 2
    CPU 2 0100 4
    CPU 3 1000 8

[geunsik@centos5.3 ~]$
[geunsik@centos5.3 ~]$  echo 8 > /proc/irq/18/smp_affinity
[geunsik@centos5.3 ~]$  for i in `ls -1 /proc/irq/*/smp_affinity`; do
echo "smp affinity CPU3 +++ $i"; echo 8 > $i; done  <--  assign  irq
to CPU3
[geunsik@centos5.3 ~]$ cat /proc/interrupts <---check irq-balancing

* Don't use irq affinity about timer irq
[geunsik@centos5.3 ~]$  echo 8 > /proc/irq/0/smp_affinity
  -bash: echo: write error: Input/output error




-- 
Regards,
GeunSik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
e-Mail: geunsik.lim@samsung.com
           leemgs@gmail.com , leemgs1@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
