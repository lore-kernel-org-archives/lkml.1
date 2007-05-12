Return-Path: <linux-kernel-owner+w=401wt.eu-S1759443AbXELSbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443AbXELSbD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXELSaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:30:55 -0400
Received: from ns1.masicom.si ([84.20.224.10]:47700 "EHLO ns1.masicom.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbXELSay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:30:54 -0400
X-Greylist: delayed 1233 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 May 2007 14:30:54 EDT
Date: Sat, 12 May 2007 20:10:19 +0200
From: Andrej Hocevar <and.hocevar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: possible kernel bug
Message-ID: <20070512181019.GA5868@stoa>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
X-Weltschmerz: A la recherche du temps perdu
X-alter-ego: Woody Allen
X-band-name: The Real Things (www.realthings.tk) | the best garage r'n'r
X-geek: GL/AT d+(>pu) s: a-@>- C++(>---) UL++ P++ L+++ !E W++ N-- o-- K w-- O? M? V? PS+ PE Y+ PGP t++ 5? X-- R- tv! b+++$>++++ DI? !D G e(>++++) h---(>) r++(*@) y+++
X-OS: Debian GNU/Linux 4.0@2.6.18zappa
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

as i've lately been forced to see the following message, i decided to
report this. i hope it's the right place to do it.

kernel: ------------[ cut here ]------------
kernel: Kernel BUG at [verbose debug info unavailable]
[...]

here is the latest bug message:

===================

May 12 19:52:52 stoa kernel: ------------[ cut here ]------------
May 12 19:52:55 stoa kernel: Kernel BUG at [verbose debug info
unavailable]
May 12 19:52:55 stoa kernel: invalid opcode: 0000 [#1]
May 12 19:52:55 stoa kernel: PREEMPT
May 12 19:52:55 stoa kernel: Modules linked in: psmouse nls_cp437 nfs
lockd sunrpc loop ppdev lp af_packet sr_mod sbp2 scsi_mod snd_intel8x0
snd_ac97_codec snd_ac97_bus snd_pcm_oss ieee80211 snd_mixer_oss
ieee80211_crypt irda parport_pc parport snd_pcm snd_timer crc_ccitt
pcspkr rtc snd_page_alloc eth1394 e100 mii ohci1394 ieee1394 ehci_hcd
uhci_hcd usbcore unix
May 12 19:52:55 stoa kernel: CPU:    0
May 12 19:52:55 stoa kernel: EIP:    0060:[<c01544a9>]    Tainted: GF
VLI
May 12 19:52:55 stoa kernel: EFLAGS: 00213046   (2.6.18zappa #1)
May 12 19:52:55 stoa kernel: EIP is at shrink_active_list+0x3e9/0x450
May 12 19:52:55 stoa kernel: eax: 00000824   ebx: c101efa0   ecx:
c100ee20   edx: c628de90
May 12 19:52:55 stoa kernel: esi: c038d7e0   edi: c628de88   ebp:
00000000   esp: c628de28
May 12 19:52:55 stoa kernel: ds: 007b   es: 007b   ss: 0068
May 12 19:52:55 stoa kernel: Process Xorg (pid: 5201, ti=c628c000
task=c6260a90 task.ti=c628c000)
May 12 19:52:55 stoa kernel: Stack: c628de98 c628de80 c038d8ac 00000009
00000000 00000000 00000000 00000001
May 12 19:52:55 stoa kernel:        c101d0c0 c1010ce0 c1011c00 c1011c20
c101e440 c101e460 c101a9a0 c1011dc0
May 12 19:52:55 stoa kernel:        c101c140 c1011de0 c100af40 c1019ca0
c10177c0 c10177e0 c628de80 c628de80
May 12 19:52:55 stoa kernel: Call Trace:
May 12 19:52:55 stoa kernel:  [<c0154fc3>] shrink_zone+0xc3/0xe0
May 12 19:52:55 stoa kernel:  [<c0155b00>] try_to_free_pages+0x140/0x250
May 12 19:52:55 stoa kernel:  [<c0150f14>] __alloc_pages+0x174/0x2e0
May 12 19:52:55 stoa kernel:  [<c0158fab>] __handle_mm_fault+0x73b/0x8d0
May 12 19:52:55 stoa kernel:  [<c0114f07>] do_page_fault+0xe7/0x5c3
May 12 19:52:55 stoa kernel:  [<c0114e20>] do_page_fault+0x0/0x5c3
May 12 19:52:55 stoa kernel:  [<c0103b75>] error_code+0x39/0x40
May 12 19:52:55 stoa kernel: Code: a8 08 75 78 8d 44 24 18 e8 75 f1 ff
ff fa 89 e0 25 00 e0 ff ff ff 40 14 e9 a5 fe ff ff 0f 0b e9 cf fe ff ff
0f 0b e9 e0 fd ff ff <0f> 0b 90 8d 74 26 00 e9 e2 fd ff ff 0f 0b e9 c3
fe ff ff 8d 74
May 12 19:52:55 stoa kernel: EIP: [<c01544a9>]
shrink_active_list+0x3e9/0x450 SS:ESP 0068:c628de28
May 12 19:52:55 stoa kernel:  <6>note: Xorg[5201] exited with
preempt_count 1

===================

output of ver_linux:

Linux stoa 2.6.18zappa #1 PREEMPT Fri Mar 2 11:10:29 CET 2007 i686
GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
pcmcia-cs              3.2.8
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
Modules Loaded         nfs lockd sunrpc loop ppdev lp af_packet sr_mod
sbp2 scsi_mod snd_intel8x0 snd_ac97_codec snd_ac97_bus snd_pcm_oss
snd_mixer_oss ieee80211 ieee80211_crypt snd_pcm snd_timer irda
snd_page_alloc crc_ccitt parport_pc parport rtc pcspkr psmouse eth1394
e100 mii ohci1394 ieee1394 ehci_hcd uhci_hcd usbcore unix

===================

i think this happens after my laptop resumes from hibernation
(hibernate/suspend2) and i try to switch to x. possibly it only started
occuring when i switched/upgraded to x.org, but am uncertain. could also
bo related to suspend2. 

regards,

	andrej

--
www.realthings.tk                       echo $girl_name > /etc/dumpdates
www.ljudmila.org/ludliteratura                 myspace.com/therealthings
