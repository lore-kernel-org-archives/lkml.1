Return-Path: <linux-kernel-owner+w=401wt.eu-S1762640AbYENTeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762640AbYENTeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYENTeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:34:36 -0400
Received: from frodo.howardsilvan.com ([66.119.206.113]:46903 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbYENTef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:34:35 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2008 15:34:35 EDT
Message-ID: <482B3D21.5020903@howardsilvan.com>
Date: Wed, 14 May 2008 12:27:29 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: troubleshooting/debugging hard locks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Please reply also directly to my e-mail address since I am not 
subscribed to the list.)

Hello,

I am using Fedora 9 (and have been for the last few weeks of the 
"preview" period... constantly updating if possible) and testing for a 
fax server using Mainpine IQ Express (PCIe) multi-modem fax cards (they 
use the 8250 serial driver).

My testing involves queuing up and sending 2000 fax jobs using HylaFAX+ 
5.2.4 to send out on two ports (1000 jobs on each port) of a 4-port card 
- receiving those calls on the other two ports.

This exact hardware works perfectly fine with similar testing in Windows 
XP Pro SP2.  However, usually on Fedora 9 (and even occasionally on 
Fedora 8) the system will lock up hard (i.e. the Numlock key does not 
light up the LED on the keyboard and SysReq keys do nothing) somewhere 
during the process.  This happens infrequently when the OS is Fedora 8 
and usually (but not always) when using Fedora 9.

There are no kernel messages on the monitor.  I've set up a remote 
serial console on ttyS0, and there are usually no messages there, 
either, when this happens.  Twice I did get messages that looked like a 
lot of this:

CPU1: Temperature above threshold, cpu clock throttled (total events = 1)
CPU0: Temperature/speed normal
CPU1: Temperature above threshold, cpu clock throttled (total events = 275)
CPU0: Temperature/speed normal
CPU1: Temperature above threshold, cpu clock throttled (total events = 577)
CPU0: Temperature/speed normal
CPU1: Temperature above threshold, cpu clock throttled (total events = 696)
CPU0: Temperature/speed normal

... but there was nothing more.  The side of the system chassis is 
removed, the fans are moving, and the hard lock still occurs even if I 
point a large fan at the open system and prevent the temperature 
warnings from occurring.  I've used sensors to monitor the temperature 
during the test with the external fan pointed at the open system, and 
the temperatures stay roughly as this:

[root@localhost ~]# sensors
it8718-isa-0290
Adapter: ISA adapter
in0:         +1.23 V  (min =  +0.00 V, max =  +4.08 V)  
in1:         +1.82 V  (min =  +0.00 V, max =  +4.08 V)  
in2:         +3.26 V  (min =  +0.00 V, max =  +4.08 V)  
in3:         +2.94 V  (min =  +0.00 V, max =  +4.08 V)  
in4:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM
in6:         +1.28 V  (min =  +0.00 V, max =  +4.08 V)  
in7:         +3.07 V  (min =  +0.00 V, max =  +4.08 V)  
in8:         +3.28 V
fan1:        688 RPM  (min =    0 RPM)
fan2:          0 RPM  (min =    0 RPM)
fan3:          0 RPM  (min =    0 RPM)
temp1:       +37.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = 
transistor
temp2:       +30.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = 
thermal diode
temp3:        -2.0°C  (low  = +127.0°C, high = +127.0°C)  sensor = 
transistor
cpu0_vid:   +1.063 V

So I tend to think that the temperature warnings are a result of a 
looming hard-lock or they're simply a red herring.

But, without kernel messages indicating where to look to debug... what 
is the best approach to start troubleshooting and debugging this 
condition?  Is there some general debug feature that can be enabled in 
the kernel that would help hone in on the culprit?

[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.25-14.fc9.i686 #1 SMP Thu May 1 06:28:41 
EDT 2008 i686 i686 i386 GNU/Linux
[root@localhost ~]# lspci
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub 
(rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82G965 Integrated 
Graphics Controller (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio 
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 1 (rev 02)
00:1c.3 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 4 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express 
Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI 
Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI 
Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface 
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port 
SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller 
(rev 02)
00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port 
SATA IDE Controller (rev 02)
01:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI 
Express-to-PCI Bridge (rev aa)
02:00.0 Communication controller: MainPine Ltd PCI <-> IOBus Bridge (rev 81)
03:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 02)
03:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 
AHCI Controller (rev 02)
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E 
Gigabit Ethernet Controller (rev 22)

Thanks,

Lee.

