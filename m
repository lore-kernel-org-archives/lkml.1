Return-Path: <linux-kernel-owner+w=401wt.eu-S1758178AbZLIW0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178AbZLIW0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 17:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758144AbZLIW0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 17:26:06 -0500
Received: from smtp12.ono.com ([62.42.230.20]:40130 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758116AbZLIW0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 17:26:05 -0500
Date: Wed, 9 Dec 2009 23:26:08 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Useless thermal acpi driver ?
Message-ID: <20091209232608.25aed4ca@werewolf.home>
X-Mailer: Claws Mail 3.7.3cvs35 (GTK+ 2.19.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I have a couple boxes where the thermal acpi driver gives this:

bran:~> sensors
acpitz-virtual-0
Adapter: Virtual device
temp1:       +26.8°C  (crit = +100.0°C)

bran:~> acpi -t
No support for device type: battery
     Thermal 1: ok, 27.0 degrees C

It stays _always_ the same, there is no difference if I run some number
crunchin, or even if one of them is overclocked from 2.8 to 3.0 GHz.
They are 1U supermicro boxes, ventilation is good, but I don't trust this
measures...
It looks like the system is using some kind of 'generic' acpi TZ driver,
but as I'm used to good-ol' sensors modules, I don't know where to look.

Previously I used the w83627hf module from sensors.
This is the system info:

bran:~# x86info
x86info v1.23.  Dave Jones 2001-2008
Feedback to <davej@redhat.com>.

Found 2 CPUs
--------------------------------------------------------------------------
CPU #1
EFamily: 0 EModel: 0 Family: 15 Model: 2 Stepping: 9
CPU Model: Pentium 4 (Northwood) [D1]
Processor name string: Intel(R) Pentium(R) 4 CPU 2.80GHz
Type: 0 (Original OEM)  Brand: 9 (Intel® Pentium® 4 processor)
Number of cores per physical package=1
Number of logical processors per socket=2
Number of logical processors per core=2
APIC ID: 0x0    Package: 0  Core: 0   SMT ID 0
--------------------------------------------------------------------------
CPU #2
EFamily: 0 EModel: 0 Family: 15 Model: 2 Stepping: 9
CPU Model: Pentium 4 (Northwood) [D1]
Processor name string: Intel(R) Pentium(R) 4 CPU 2.80GHz
Type: 0 (Original OEM)  Brand: 9 (Intel® Pentium® 4 processor)
Number of cores per physical package=1
Number of logical processors per socket=2
Number of logical processors per core=2
APIC ID: 0x1    Package: 0  Core: 0   SMT ID 1
--------------------------------------------------------------------------
bran:~# lspci
00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller Hub (rev 02)
00:01.0 PCI bridge: Intel Corporation 82875P Processor to AGP Controller (rev 02)
00:06.0 System peripheral: Intel Corporation 82875P/E7210 Processor to I/O Memory Interface (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 02)
02:03.0 Ethernet controller: Intel Corporation 82543GC Gigabit Ethernet Controller (Copper) (rev 02)
02:09.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
02:0a.0 Ethernet controller: Intel Corporation 82541EI Gigabit Ethernet Controller
02:0b.0 Ethernet controller: Intel Corporation 82541EI Gigabit Ethernet Controller

dmidecode for mobo:

System Information
    Manufacturer: Supermicro
    Product Name: P4SCE
    Version: 1234567890
    Serial Number: 1234567890
    UUID: Not Present
    Wake-up Type: Power Switch


Is there any acpi driver for this kind of box ?

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2010.0 (Cooker) for x86_64
Linux 2.6.29.3-desktop-1mnb (gcc 4.3.2 (GCC) #1 Wed May
