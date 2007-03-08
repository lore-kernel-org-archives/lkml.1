Return-Path: <linux-kernel-owner+w=401wt.eu-S1030380AbXCHJPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbXCHJPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:15:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030381AbXCHJPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:15:12 -0500
Received: from laposte.rennes.enst-bretagne.fr ([192.44.77.17]:53757 "EHLO
	laposte.rennes.enst-bretagne.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030380AbXCHJO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:14:59 -0500
X-Greylist: delayed 1793 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 04:14:59 EST
Message-ID: <45EFCD0D.1090805@free.fr>
Date: Thu, 08 Mar 2007 09:45:01 +0100
From: Kevin Perros <kevin.perros@free.fr>
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Frank Hartmann <soundart@gmx.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.6.19.1 Oops while doing Disk IO + playing sound, 2.6.20
 too ->  STATUS git-bisect
References: <877ivr6t0k.fsf@fantasio.hh.de>	<20070207091841.GE24590@atrey.karlin.mff.cuni.cz>	<87wt2thhux.fsf@fantasio.hh.de> <20070208093930.GB10973@duck.suse.cz>	<87bqk06bhi.fsf_-_@fantasio.hh.de> <20070214143249.GE23203@duck.suse.cz>	<87r6ssl3g4.fsf@fantasio.hh.de> <20070215094053.GA28205@duck.suse.cz>	<87mz3f9gab.fsf@fantasio.hh.de> <20070216092909.GA1711@duck.suse.cz> <877itxmmkv.fsf_-_@fantasio.hh.de>
In-Reply-To: <877itxmmkv.fsf_-_@fantasio.hh.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just had the same problem with a 2.6.20 kernel, just after the boot, 
after having launched Mozilla Firefox. The browser seemed to lag while 
rendering a page, and after say 20 seconds, I got an oops.

I was *not* playing sound.

This message is repeated a HUGE amount of times in my syslog :

__find_get_block_slow() failed. block=1570988, b_blocknr=1562796
b_state=0x00000029, b_size=4096
device blocksize: 4096

And finally, I got the Ooops:

BUG: unable to handle kernel paging request at virtual address 0491c624
  printing eip:
c0180ceb
*pde = 00000000
Oops: 0002 [#1]
PREEMPT
Modules linked in: binfmt_misc ipv6 video container button battery ac 
af_packet tsdev usbhid snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss 
snd_mixer_oss psmouse e1000 snd_pcm snd_timer serio_raw evdev intel_agp 
agpgart snd soundcore snd_page_alloc rtc ext3 jbd ehci_hcd uhci_hcd 
usbcore ide_generic ide_cd cdrom ide_disk piix generic ide_core thermal 
processor fan
CPU:    0
EIP:    0060:[drop_buffers+91/240]    Not tainted VLI
EFLAGS: 00010286   (2.6.20 #1)
EIP is at drop_buffers+0x5b/0xf0
eax: df91c620   ebx: df91c5f8   ecx: df91c620   edx: 0491c620
esi: df91c5f8   edi: c13f3a80   ebp: df91c5f8   esp: dfa13ddc
ds: 007b   es: 007b   ss: 0068
Process kswapd0 (pid: 108, ti=dfa12000 task=dfa55550 task.ti=dfa12000)
Stack: c12d8ea0 00000000 c01550c5 dfa6cbbc dfa13e04 c13f3a80 00000000 
00000001
        c13f3a98 c0180db8 00000000 c13f3a80 c031ec44 c0149a1d dfa13f08 
00000000
        dfa13ef8 dfa13f00 c031ed14 dfa13f78 00000020 00000000 00000000 
00000020
Call Trace:
  [move_to_swap_cache+69/96] move_to_swap_cache+0x45/0x60
  [try_to_free_buffers+56/160] try_to_free_buffers+0x38/0xa0
  [shrink_inactive_list+1805/2128] shrink_inactive_list+0x70d/0x850
  [__pagevec_release+21/32] __pagevec_release+0x15/0x20
  [shrink_zone+152/256] shrink_zone+0x98/0x100
  [kswapd+797/1072] kswapd+0x31d/0x430
  [autoremove_wake_function+0/80] autoremove_wake_function+0x0/0x50
  [kswapd+0/1072] kswapd+0x0/0x430
  [kthread+168/224] kthread+0xa8/0xe0
  [kthread+0/224] kthread+0x0/0xe0
  [kernel_thread_helper+7/20] kernel_thread_helper+0x7/0x14
  =======================
Code: 8b 02 83 e0 06 0b 42 34 75 74 8b 52 04 39 d6 75 dc 89 f3 eb 06 39 
ee 89 eb 74 3e 8b 53 28 8d 4b 28 8b 6b 04 39 d1 74 ed 8b 41 04 <89> 42 
04 89 10 89 49 04 89 4b 28 8b 4b 30 85 c9 74 4b 8b 03 f6
EIP: [drop_buffers+91/240] drop_buffers+0x5b/0xf0 SS:ESP 0068:dfa13ddc
  <6>note: kswapd0[108] exited with preempt_count 1
