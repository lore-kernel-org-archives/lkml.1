Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbYJYOxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbYJYOxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYJYOxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:53:32 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:45575 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYJYOxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=b/adZrixu26HM9SUZc0ad/woi4m/e/lfNGlpZUkPtJuBlTtA9gs0KZcekMTsFlLqxB
         2BOmDFnpF8oRE+MnMJRE12bViN16awrd0mwOtsoijuOsflCb72rJ8MSJVhHZ81flQjoR
         On9AOr12jlM7QtBpqb4qkMRGKr6GcS+jp2aLg=
Message-ID: <490332E5.3020108@gmail.com>
Date: Sat, 25 Oct 2008 16:53:25 +0200
From: "Mikko C." <mikko.cal@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080927)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Random problems with 2.6.28-rc1-git1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Today I tried upgrading to 2.6.28-rc1-git1 (-rc1 couldn't even mount the 
disk).
I'm having some problems with it :)

1) Whenever I try to unload (rmmod or modprobe -r) *any* modules (even 
if not used), the system hangs.
I can still move the mouse and see the cursor moving, but I can't type, 
can't switch console, nothing.
Because of this, I can't shutdown the system properly because it hangs 
when "Unloading ALSA modules"

2) Sometimes (randomly it seems) the system doesn't detect any usb devices:
I have an external HD and a Logitech mouse. Sometimes they are 
recognized, sometimes not.
Unplugging and re-plugging them doesn't help. lsusb shows no attached 
device.

3) Sometimes (randomly) the wireless doesn't work: it can associate to 
the AP,
but it can't receive an IP in any way: both dhcp and static ip don't work.
The rate is fixed to 1Mb/s, instead of 54, and changing it manually 
doesn't work.
Restarting the wifi service doesn't help.
Reloading the module isn't an option, because of 1)

There can be different combinations of 2) and 3):
- wifi works / usb doesn't
- disk is recognized / mouse isn't
- everything works (rarely), etc...

4) Applications that use sound don't work:
-Mozilla Thunderbird freezes whenever I receive a message
-Amarok crashes at start
-mplayer doesn't work
The thing is, if I try to kill them, I can't, no matter what.
KSysguard says they are in "disk sleep", see: 
http://i34.tinypic.com/eg390j.png


None of these problems are present in 2.6.27.2 and previous.
My .config is very similar to 2.6.27.2 (see the diff below).

Laptop is a Dell Inspiron 6400.

dmesg when both usb and wifi don't work: http://zlin.dk/p/?OGRmMjQz.txt
dmesg when both usb and wifi work: http://zlin.dk/p/?NzIxMzZh.txt


$ cat /proc/version
Linux version 2.6.28-rc1-git1 (root@gentoo) (gcc version 4.3.2 (Gentoo 
4.3.2 p1.0) ) #10 SMP PREEMPT Sat Oct 25 13:17:27 CEST 2008

$ uname -a
Linux gentoo 2.6.28-rc1-git1 #10 SMP PREEMPT Sat Oct 25 13:17:27 CEST 
2008 x86_64 Intel(R) Core(TM)2 CPU T7200 @ 2.00GHz GenuineIntel GNU/Linux

$ cat /proc/modules
usb_storage 53504 1 - Live 0xffffffffa0196000
radeon 152032 1 - Live 0xffffffffa016e000
drm 179616 2 radeon, Live 0xffffffffa0140000
snd_seq 56224 0 - Live 0xffffffffa0130000
snd_seq_device 7252 1 snd_seq, Live 0xffffffffa012c000
vfat 12352 1 - Live 0xffffffffa0126000
fat 53048 1 vfat, Live 0xffffffffa0117000
coretemp 6400 0 - Live 0xffffffffa0113000
hwmon 2888 1 coretemp, Live 0xffffffffa0059000
cpufreq_ondemand 8400 1 - Live 0xffffffffa010e000
fan 4096 0 - Live 0xffffffffa000f000
snd_hda_intel 127688 1 - Live 0xffffffffa00ec000
snd_pcm 73288 1 snd_hda_intel, Live 0xffffffffa00d8000
psmouse 46108 0 - Live 0xffffffffa00ca000
iwl3945 177912 0 - Live 0xffffffffa0099000
snd_timer 22608 2 snd_seq,snd_pcm, Live 0xffffffffa008e000
evdev 11936 9 - Live 0xffffffffa0086000
uhci_hcd 25176 0 - Live 0xffffffffa007a000
button 7392 0 - Live 0xffffffffa0073000
battery 7680 0 - Live 0xffffffffa006c000
ac 3840 0 - Live 0xffffffffa0066000
thermal 18784 1 - Live 0xffffffffa005c000
snd 55368 7 snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer, Live 
0xffffffffa0049000
soundcore 1736 1 snd, Live 0xffffffffa0043000
snd_page_alloc 9680 2 snd_hda_intel,snd_pcm, Live 0xffffffffa003b000
mac80211 145616 1 iwl3945, Live 0xffffffffa0012000
led_class 4296 1 iwl3945, Live 0xffffffffa000b000
cfg80211 34208 2 iwl3945,mac80211, Live 0xffffffffa0000000

$ cat /proc/cpuinfo
processor       : 0                        
vendor_id       : GenuineIntel             
cpu family      : 6                        
model           : 15                       
model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping        : 6                                             
cpu MHz         : 1000.000                                      
cache size      : 4096 KB                                       
physical id     : 0                                             
siblings        : 2                                             
core id         : 0                                             
cpu cores       : 2                                             
apicid          : 0                                             
initial apicid  : 0                                             
fpu             : yes                                           
fpu_exception   : yes                                           
cpuid level     : 10                                            
wp              : yes                                           
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni 
monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr 
lahf_lm                                                                                                                     

bogomips        : 
3994.55                                                                                                   

clflush size    : 
64                                                                                                        

cache_alignment : 
64                                                                                                        

address sizes   : 36 bits physical, 48 bits 
virtual                                                                         

power 
management:                                                                                                           


processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
stepping        : 6
cpu MHz         : 1000.000
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
apicid          : 1
initial apicid  : 1
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe 
syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl pni 
monitor ds_cpl vmx est tm2 ssse3 cx16 xtprlahf_lm
bogomips        : 3994.45
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


$ lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express Memory Controller Hub (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express PCI Express Root Port (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 4 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA 
IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon Mobility 
X1400
03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
(rev 02)
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro 
Host Adapter (rev 19)
03:01.2 System peripheral: Ricoh Co Ltd Device 0843 (rev 01)
03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
Adapter (rev 0a)
03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
0b:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
Network Connection (rev 02)


2.6.28-rc1-git .config: http://zlin.dk/p/?OGY2NWM5.txt
Diff between 2.6.27.2 .config and 2.6.28-rc1-git1: 
http://zlin.dk/p/?NWUwZDEz.txt

I'd be glad to give more info if needed, please let me know.

Thanks!

P.S: I'm not subscribed, can you please CC me if answering?
