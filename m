Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZFHJTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZFHJTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 05:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZFHJTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 05:19:46 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:62535 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbZFHJTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 05:19:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-disposition
         :content-type:content-transfer-encoding:message-id;
        b=eVaa0l39FkQxKFEkCu0lqOwkOom8W4+weXzpWmt9BQFK6ouAuxgoXhMfKfnkO5bGMg
         B8YqN09YqrKQMeVdNW9jkpX81TZYZQx76Znx4PSO0d/++E/G3jFHiw8Nws4euI2e5rPS
         g5u/Yh6NKN8N4qN0sSm7R9vjn4Vcg9/wAzX+o=
From: Jonathan Cervidae <jonathan.cervidae@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Removing Huawei E220 HSDPA Modem causes system to completely hang
Date: Mon, 8 Jun 2009 10:19:59 +0100
User-Agent: KMail/1.11.2 (Linux/2.6.29.4-167.fc11.i586; KDE/4.2.3; i686; ; )
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200906081019.59958.jonathan.cervidae@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at first the easy fix to this issue would be "Don't remove modem", 
sometimes it resets itself and therefore appears to disconnect and reconnect 
which causes the system crash.

I can reproduce the problem 80% of the time by ripping the modem out of the 
USB port. However, if I kill -9 pppd before doing it, it never happens so the 
problem appears to be an interaction between pppd and the kernel. As full 
system lockups in my limited knowledge must be kernel problems since systems 
should never fully lock (with flashing caps lock and scroll lock lights, not 
responsive to magic sysreq keys) presumably this is a kernel bug.

It also did not happen until recently, some point within the last month. I 
would have reported it earlier (and reverted to a kernel that didn't do it) 
but didn't realise why it was happening.

If I can provide more information to help then I will do my best.

Possibly relevant is I connect to the internet with a udev rule:

SUBSYSTEM=="tty", SUBSYSTEMS=="usb", DRIVERS=="option", 
ATTRS{bInterfaceNumber}=="00", NAME="hsdpa", RUN+="/usr/bin/wvdial 
&>/dev/null&"

Keywords: networking, pppd, kernel, crash

Linux[root@jaydee ~]# cat /proc/version
Linux version 2.6.29.4-167.fc11.i586 (mockbuild@x86-2.fedora.phx.redhat.com) 
(gcc version 4.4.0 20090506 (Red Hat 4.4.0-4) (GCC) ) #1 SMP Wed May 27 
17:14:37 EDT 2009

[root@jaydee ~]# /usr/src/kernels/2.6.29.4-167.fc11.i586/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.                                                                 
Compare to the current minimal requirements in Documentation/Changes.                                                                 
                                                                                                                                      
Linux jaydee 2.6.29.4-167.fc11.i586 #1 SMP Wed May 27 17:14:37 EDT 2009 i686 
i686 i386 GNU/Linux                                      
                                                                                                                                      

Gnu C                  4.4.0
Gnu make               3.81
binutils               2.19.51.0.2
util-linux             2.14.2
mount                  support
module-init-tools      3.7-pre9
e2fsprogs              1.41.4
xfsprogs               3.0.0
pcmciautils            015
quota-tools            3.17.
PPP                    2.4.4
Linux C Library        2.10.1
Dynamic linker (ldd)   2.10.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.15
oprofile               0.9.4
Sh-utils               7.2
wireless-tools         29
Modules Loaded         ppp_deflate zlib_deflate ppp_async crc_ccitt ppp_generic 
slhc bridge stp llc bnep sco l2cap bluetooth vboxnetflt vboxdrv sunrpc 
ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 p4_clockmod 
dm_multipath uinput snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd 
soundcore option pcspkr iTCO_wdt serio_raw 8139too snd_page_alloc i2c_i801 
iTCO_vendor_support 8139cp usbserial usb_storage mii nvidia ata_generic 
pata_acpi sha256_generic cbc aes_i586 aes_generic dm_crypt nouveau drm 
i2c_algo_bit i2c_core

[root@jaydee ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.80GHz
stepping        : 9
cpu MHz         : 2800.000
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat 
pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe up pebs bts cid xtpr
bogomips        : 5600.37
clflush size    : 64
power management:

[root@jaydee ~]# cat /proc/modules
ppp_deflate 4124 0 - Live 0xf8d1f000
zlib_deflate 16980 1 ppp_deflate, Live 0xf8d18000
ppp_async 7704 0 - Live 0xf82fd000               
crc_ccitt 1588 1 ppp_async, Live 0xf7c7e000      
ppp_generic 19396 2 ppp_deflate,ppp_async, Live 0xf7c65000
slhc 4456 1 ppp_generic, Live 0xf7c3b000                  
bridge 41488 0 - Live 0xf9c22000                          
stp 1944 1 bridge, Live 0xf9c0c000                        
llc 4780 2 bridge,stp, Live 0xf9bfa000                    
bnep 10888 2 - Live 0xf9bba000                            
sco 9356 2 - Live 0xf9b90000
l2cap 18884 3 bnep, Live 0xf9b40000
bluetooth 44776 5 bnep,sco,l2cap, Live 0xf99db000
vboxnetflt 70024 0 - Live 0xf9987000
vboxdrv 94848 1 vboxnetflt, Live 0xf993c000
sunrpc 152364 1 - Live 0xf9617000
ip6t_REJECT 3160 3 - Live 0xf95cc000
nf_conntrack_ipv6 11368 3 - Live 0xf9590000
ip6table_filter 3136 1 - Live 0xf9581000
ip6_tables 10728 1 ip6table_filter, Live 0xf9575000
ipv6 232324 20 ip6t_REJECT,nf_conntrack_ipv6, Live 0xf906d000
p4_clockmod 4208 0 - Live 0xf901d000
dm_multipath 13512 0 - Live 0xf842d000
uinput 6496 0 - Live 0xf7c33000
snd_intel8x0 27440 3 - Live 0xf8d73000
snd_ac97_codec 91752 1 snd_intel8x0, Live 0xf8d3b000
ac97_bus 1400 1 snd_ac97_codec, Live 0xf8d0e000
snd_pcm 62520 2 snd_intel8x0,snd_ac97_codec, Live 0xf84cf000
snd_timer 17896 1 snd_pcm, Live 0xf82ef000
snd 49044 10 snd_intel8x0,snd_ac97_codec,snd_pcm,snd_timer, Live 0xf8418000
soundcore 5404 1 snd, Live 0xf82c0000
option 18892 1 - Live 0xf7c6f000
pcspkr 2156 0 - Live 0xf7c49000
iTCO_wdt 10448 0 - Live 0xf7c36000
serio_raw 4852 0 - Live 0xf7c19000
8139too 20844 0 - Live 0xf8d8c000
snd_page_alloc 7572 2 snd_intel8x0,snd_pcm, Live 0xf8d7b000
i2c_i801 8056 0 - Live 0xf8d6f000
iTCO_vendor_support 2736 1 iTCO_wdt, Live 0xf82d4000
8139cp 17696 0 - Live 0xf84f6000
usbserial 26784 3 option, Live 0xf84be000
usb_storage 82508 0 - Live 0xf7c4e000
mii 4008 2 8139too,8139cp, Live 0xfa3f6000
nvidia 7082172 34 - Live 0xf9ceb000 (P)
ata_generic 4264 0 - Live 0xf8402000
pata_acpi 3624 0 - Live 0xf82f6000
sha256_generic 11720 0 - Live 0xf82ea000
cbc 3024 1 - Live 0xf82de000
aes_i586 7416 2 - Live 0xf82d6000
aes_generic 26892 1 aes_i586, Live 0xf82c7000
dm_crypt 11008 1 - Live 0xf7c24000
nouveau 433172 0 - Live 0xf8452000
drm 165220 1 nouveau, Live 0xf8282000
i2c_algo_bit 4788 1 nouveau, Live 0xf7c2b000
i2c_core 18016 5 i2c_i801,nvidia,nouveau,drm,i2c_algo_bit, Live 0xf7c1d000

[root@jaydee ~]# cat /proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cf3ff : Video ROM
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3ffeffff : System RAM
  00400000-0070be49 : Kernel code
  0070be4a-008e5a17 : Kernel data
  00956000-00a0be13 : Kernel bss
3fff0000-3fff2fff : ACPI Non-volatile Storage
3fff3000-3fffffff : ACPI Tables
50000000-500fffff : PCI Bus 0000:02
  50000000-5000ffff : 0000:02:0c.0
50100000-501003ff : 0000:00:1f.1
d0000000-d7ffffff : PCI Bus 0000:01
  d0000000-d7ffffff : 0000:01:00.0
    d0000000-d7ffffff : vesafb
d8000000-dbffffff : 0000:00:00.0
dc000000-ddffffff : PCI Bus 0000:01
  dc000000-dcffffff : 0000:01:00.0
    dc000000-dcffffff : nvidia
  dd000000-dd01ffff : 0000:01:00.0
de000000-dfffffff : PCI Bus 0000:02
  df000000-df00ffff : 0000:02:0a.0
  df010000-df0100ff : 0000:02:0c.0
    df010000-df0100ff : 8139too
e0000000-e00003ff : 0000:00:1d.7
  e0000000-e00003ff : ehci_hcd
e0001000-e00011ff : 0000:00:1f.5
  e0001000-e00011ff : Intel 82801DB-ICH4
e0002000-e00020ff : 0000:00:1f.5
  e0002000-e00020ff : Intel 82801DB-ICH4
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
  fee00000-fee00fff : Local APIC

[root@jaydee ~]# lspci -vvv as root

command reacted with an invalid usage. You may need to change 
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html ?

I took a guess at you wanted -xxxx

[root@jaydee ~]# lspci -xxxx                                                  
00:00.0 Host bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM 
Controller/Host-Hub Interface (rev 03)
00: 86 80 60 25 06 00 90 20 03 00 00 06 00 00 00 00                                                            
10: 08 00 00 d8 00 00 00 00 00 00 00 00 00 00 00 00                                                            
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 70 57                                                            
30: 00 00 00 00 e4 00 00 00 00 00 00 00 00 00 00 00                                                            
40: bc 05 00 00 41 20 10 20 04 01 00 00 3b 08 10 00                                                            
50: 00 02 0a 00 00 00 00 01 44 3e 00 00 37 32 35 32                                                            
60: 08 10 18 20 00 00 00 00 00 00 00 00 00 00 00 00                                                            
70: 22 22 00 00 00 00 00 00 25 04 40 2b 71 81 00 20                                                            
80: f5 00 af 00 ad 00 00 00 01 00 00 00 00 00 00 00                                                            
90: 10 11 11 33 00 00 00 00 45 04 00 00 00 0a 38 00                                                            
a0: 02 00 20 00 17 02 00 1f 04 01 00 00 00 00 00 00                                                            
b0: 80 00 00 00 30 00 00 00 00 00 64 36 10 10 00 00                                                            
c0: 44 40 30 11 00 00 0c 08 00 00 00 00 00 00 00 00                                                            
d0: 02 28 04 0e 0b 0d 00 10 00 00 11 b3 00 00 20 00                                                            
e0: 00 00 00 00 09 a0 05 41 21 00 00 00 00 00 00 00                                                            
f0: 00 00 00 00 74 fc 00 00 40 0f 00 00 04 00 00 00                                                            

00:01.0 PCI bridge: Intel Corporation 82845G/GL[Brookdale-G]/GE/PE Host-to-AGP 
Bridge (rev 03)
00: 86 80 61 25 07 01 a0 00 03 00 04 06 00 40 01 00                                           
10: 00 00 00 00 00 00 00 00 00 01 01 20 f0 00 a0 22                                           
20: 00 dc f0 dd 00 d0 f0 d7 00 00 00 00 00 00 00 00                                           
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0c 00                                           
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                           

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #1 (rev 02)
00: 86 80 c2 24 05 00 80 02 02 00 03 0c 00 00 80 00                                                           
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
20: 01 d8 00 00 00 00 00 00 00 00 00 00 62 14 70 57                                                           
30: 00 00 00 00 00 00 00 00 00 00 00 00 0a 01 00 00                                                           
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00                                                           

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #2 (rev 02)
00: 86 80 c4 24 05 00 80 02 02 00 03 0c 00 00 00 00                                                           
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
20: 01 d0 00 00 00 00 00 00 00 00 00 00 62 14 70 57                                                           
30: 00 00 00 00 00 00 00 00 00 00 00 00 0b 02 00 00                                                           
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00                                                           

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) 
USB UHCI Controller #3 (rev 02)
00: 86 80 c7 24 05 00 80 02 02 00 03 0c 00 00 00 00                                                           
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
20: 01 d4 00 00 00 00 00 00 00 00 00 00 62 14 70 57                                                           
30: 00 00 00 00 00 00 00 00 00 00 00 00 09 03 00 00                                                           
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
60: 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
c0: 00 2f 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                           
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00                                                           

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI 
Controller (rev 02)
00: 86 80 cd 24 06 00 90 02 02 20 03 0c 00 00 00 00                                              
10: 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00 00                                              
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 70 57                                              
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00                                              
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                              
50: 01 00 c2 c9 00 00 00 00 0a 00 80 20 00 00 00 00                                              
60: 20 20 7f 00 00 00 00 00 01 00 00 00 00 00 08 c0                                              
70: 00 00 ff 0f 00 00 00 00 00 00 00 00 00 00 00 00                                              
80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00                                              
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                              
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                              
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                              
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                              
d0: 00 00 00 00 00 00 00 00 00 00 00 00 10 00 15 00                                              
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                              
f0: 78 bf 1f 00 88 83 00 00 60 0f 00 00 06 00 00 00                                              

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 82)
00: 86 80 4e 24 07 01 80 80 82 00 04 06 00 00 01 00            
10: 00 00 00 00 00 00 00 00 00 02 02 20 c0 c0 80 02            
20: 00 de f0 df 00 50 00 50 00 00 00 00 00 00 00 00            
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 06 00            
40: 02 28 20 00 00 00 00 00 00 00 00 00 00 00 00 00            
50: 02 74 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
70: 60 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
80: 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00 00            
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
a0: 10 00 08 00 00 00 00 00 00 00 00 00 00 00 00 00            
b0: 01 00 02 00 00 00 c0 00 00 00 00 00 00 00 00 00            
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00            
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 54 22            

00:1f.0 ISA bridge: Intel Corporation 82801DB/DBL (ICH4/ICH4-L) LPC Interface 
Bridge (rev 02)
00: 86 80 c0 24 0f 00 80 02 02 00 01 06 00 00 80 00                                          
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
20: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
40: 01 04 00 00 10 00 00 00 00 00 00 00 00 00 00 00                                          
50: 00 00 00 00 08 00 00 00 81 04 00 00 10 00 00 00                                          
60: 0a 05 09 0b d0 00 00 00 80 80 03 0b 00 00 00 00                                          
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
90: f5 54 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
a0: 20 02 00 00 00 00 00 00 0d 00 00 00 00 00 00 00                                          
b0: 00 00 00 00 00 00 00 00 55 55 41 05 00 00 00 00                                          
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                          
d0: 86 21 00 00 02 0f 00 00 04 00 00 00 00 00 00 00                                          
e0: 00 00 00 c0 00 00 0d 34 33 22 11 00 91 02 67 45                                          
f0: 0f 00 40 00 00 00 00 00 60 0f 02 00 00 00 81 00                                          

00:1f.1 IDE interface: Intel Corporation 82801DB (ICH4) IDE Controller (rev 
02)
00: 86 80 cb 24 07 00 80 02 02 8a 01 01 00 00 00 00                            
10: 01 00 00 00 01 00 00 00 01 00 00 00 01 00 00 00                            
20: 01 f0 00 00 00 00 10 50 00 00 00 00 62 14 70 57                            
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00                            
40: 70 c0 37 e3 bb 00 00 00 0e 00 10 22 00 00 00 00                            
50: 00 00 00 00 30 24 00 00 00 00 00 00 00 00 00 00                            
60: 08 00 00 00 00 00 00 00 08 00 00 00 00 00 00 00                            
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                            
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00                            

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus 
Controller (rev 02)
00: 86 80 c3 24 01 00 80 02 02 00 05 0c 00 00 00 00                                            
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
20: 01 05 00 00 00 00 00 00 00 00 00 00 62 14 70 57                                            
30: 00 00 00 00 00 00 00 00 00 00 00 00 05 02 00 00                                            
40: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                            
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00                                            

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM 
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 02)
00: 86 80 c5 24 07 00 90 02 02 00 01 04 00 00 00 00                                                                        
10: 01 e0 00 00 01 e4 00 00 00 10 00 e0 00 20 00 e0                                                                        
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 71 57                                                                        
30: 00 00 00 00 50 00 00 00 00 00 00 00 05 02 00 00                                                                        
40: 09 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
50: 01 00 c2 c9 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                        
f0: 00 00 00 00 00 00 00 00 60 0f 00 00 00 00 00 00                                                                        

01:00.0 VGA compatible controller: nVidia Corporation NV34 [GeForce FX 5200] 
(rev a1)
00: de 10 22 03 07 00 b0 02 a1 00 00 03 00 f8 00 00                                  
10: 00 00 00 dc 08 00 00 d0 00 00 00 00 00 00 00 00                                  
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 74 91                                  
30: 00 00 00 00 60 00 00 00 00 00 00 00 0a 01 05 01                                  
40: 62 14 74 91 02 00 30 00 17 02 00 1f 04 01 00 1f                                  
50: 01 00 00 00 01 00 00 00 ce d6 23 00 0f 00 00 00                                  
60: 01 44 02 00 00 00 00 00 00 00 00 00 00 00 00 00                                  
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                  
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:0a.0 Communication controller: Conexant Systems, Inc. HSF 56k HSFi Modem 
(rev 01)
00: f1 14 00 2f 07 00 90 02 01 00 80 07 00 20 00 00
10: 00 00 00 df 01 c0 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 e0 13 85 8d
30: 00 00 00 00 40 00 00 00 00 00 00 00 03 01 00 00
40: 01 00 22 c0 00 00 00 00 52 12 01 00 01 00 00 00
50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

02:0c.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
00: ec 10 39 81 07 00 90 02 10 00 00 02 00 20 00 00
10: 01 c4 00 00 00 00 01 df 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 62 14 7c 57
30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 01 20 40
40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
50: 01 00 c2 f7 00 00 00 00 00 00 00 00 00 00 00 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

[root@jaydee ~]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: WDC WD1200JB-00D Rev: 75.1
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3200822A       Rev: 3.01
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 01 Lun: 00
  Vendor: _NEC     Model: DVD_RW ND-3500AG Rev: 2.16
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 9138
  Type:   Direct-Access                    ANSI  SCSI revision: 00
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: Generic  Model: STORAGE DEVICE   Rev: 9138
  Type:   Direct-Access                    ANSI  SCSI revision: 00

