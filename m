Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbXBNPlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbXBNPlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 10:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbXBNPlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 10:41:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:54728 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932343AbXBNPlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 10:41:10 -0500
X-Provags-ID: V01U2FsdGVkX18ZCsgCrx4ZWrk5EFQPq3J+DO7OxXF5jzMKgX7hzW
	k/ZA==
Message-ID: <45D32E78.7090309@gmx.net>
Date: Wed, 14 Feb 2007 16:44:56 +0100
From: Dragan Noveski <perodog@gmx.net>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: atmel-wlan-driver in 2.6.20-rt5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

hi to the list!

i have problems getting the at76c503a-driver running on linux-2.6.20-rt5.

since i did not subscribed to the list, please add my email address  as 
CC for all postings which are related to this one, so that i receive it.

the problem is this: i just build the 2.6.20 kernel and applied the 
realtime patch from ingo molnar:


http://people.redhat.com/mingo/realtime-preempt/older/

before i was using 2.6.18 also patched with the rt-patch and everything 
was running fine.
with the 2.6.20 i am able to build the atmel-driver but it works very 
unstable.
the real problem is that when the atmel driver crashes, i am not able to 
`rmmod` and than doing modprobe again, when i type `rmmod at76_usb` in 
the console, just nothing happens.
lately  than, when i try  to stop the network protocol  which is started 
with:


#!/bin/sh
    iwconfig wlan0 mode ad-hoc essid olsr.freifunk.net channel 10
    ifconfig wlan0 104.130.30.9
    ifconfig wlan0 up
    olsrd


i don´t get the right response in the console, but the cursor moves down 
in a very fast speed.
than i have to make a hard-reset.

since i already talked to the people from debian and the developer from 
berlios, i guess that there is some kernel-thing going up, because if 
the driver is crashing, i  think that i should be able to `rmmod´ but it 
looks like the driver crash takes the hole kernel into an crash too.

here is the output of dmesg, well the last part which appears when the 
driver crashes:


divide error: 0000 [#1]
PREEMPT
Modules linked in: thermal fan button processor ac battery snd_intel8x0m
at76_usb uhci_hcd snd_intel8x0 snd_ac97_codec ac97_bus e100 ipw2200
ieee80211 ieee80211_crypt yenta_socket rsrc_nonstatic pcmcia_core i2c_i801
ide_cd cdrom snd_hdsp snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc
snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd rtc
CPU:    0
EIP:    0060:[<e025dfb7>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-rt5Centrino #1) 
EIP is at update_wstats+0x6c/0xb6 [at76_usb]
eax: 00000000   ebx: 00000000   ecx: 00000000   edx: 00000000
esi: dea222c0   edi: dea22326   ebp: dc0d5000   esp: df681e3c
ds: 007b   es: 007b   ss: 0068   preempt: 00000001
Process softirq-tasklet (pid: 8, ti=df681000 task=c147f550 task.ti=df681000)
Stack: dea224e8 00000080 dc0d500c e02607b7 00000001 00000000 00000006
df3bc740
       de9d2d40 df425000 dedbcc00 c0124d19 dea222c0 de0046fc df6c61c0
00000002
       00000002 e022a7a5 00000001 00000001 00000001 dc0d504d 00000000
00000021  
Call Trace:
 [<e02607b7>] rx_mgmt+0x80/0x113a [at76_usb]
 [<c0124d19>] __queue_work+0x54/0x5e
 [<e022a7a5>] ipw_rx_queue_restock+0x8c/0xb9 [ipw2200]
 [<c011e357>] __get_nsec_offset+0xd/0x44
 [<c01557d9>] __kmalloc+0x73/0x7e 
 [<c02a9041>] __alloc_skb+0x4f/0xf6
 [<e02600e1>] submit_rx_urb+0x1d6/0x26f [at76_usb]
 [<c01135c8>] __activate_task+0x1c/0x28
 [<e02656d0>] rx_tasklet+0x10bc/0x1146 [at76_usb]
 [<c012767e>] autoremove_wake_function+0x15/0x35
 [<c01132b4>] __wake_up_common+0x32/0x55
 [<c0114c1a>] __wake_up+0x36/0x59
 [<c011b390>] __tasklet_action+0xe2/0x121
 [<c030d752>] schedule+0xe0/0xfa 
 [<c011b79d>] ksoftirqd+0x0/0x14f
 [<c011b86d>] ksoftirqd+0xd0/0x14f
 [<c01275ae>] kthread+0xa0/0xca
 [<c012750e>] kthread+0x0/0xca
 [<c0103857>] kernel_thread_helper+0x7/0x10
 =======================
Code: 86 a0 07 00 00 0f af 86 a4 07 00 00 0f b6 5f 01 0f af d8 a1 60 c3 3a 
c0 e8 05 cd eb df 89 c2 89 d8 2b 96 a8 07 00 00 89 d1 31 d2 <f7> f1 88 46 66
a1 60 c3 3a c0 e8 e8 cc eb df c7 86 a4 07 00 00
EIP: [<e025dfb7>] update_wstats+0x6c/0xb6 [at76_usb] SS:ESP 0068:df681e3c
 <3>ipw2200: Failed to send SCAN_ABORT: Command timed out.
ipw2200: Failed to send CARD_DISABLE: Command timed out. 
ipw2200: Failed to send TX_POWER: Command timed out.
ipw2200: Failed to send TX_POWER: Command timed out.
ipw2200: Failed to send TX_POWER: Command timed out.
/home/nowhiskey/software/wlan/at76c503a/at76c503.c: wlan0: lost beacon bssid
02:ca:ff:ee:ba:be
ipw2200: Failed to send TX_POWER: Command timed out.
ipw2200: Failed to send TX_POWER: Command timed out.
ipw2200: Unable to initialize device after 5 attempts.
ipw2200: Failed to up device
nowhiskey@murija2:~$ 


and here is another one, they differ a little:


divide error: 0000 [#1]
PREEMPT
Modules linked in: thermal fan button processor ac battery snd_intel8x0m
at76_usb uhci_hcd snd_intel8x0 snd_ac97_codec ac97_bus e100 ipw2200
ieee80211 ieee80211_crypt yenta_socket rsrc_nonstatic pcmcia_core i2c_i801
ide_cd cdrom snd_hdsp snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc
snd_hwdep snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd rtc
CPU:    0
EIP:    0060:[<e025dfb7>]    Not tainted VLI
EFLAGS: 00010246   (2.6.20-rt5Centrino #1) 
EIP is at update_wstats+0x6c/0xb6 [at76_usb]
eax: 000002bc   ebx: 000002bc   ecx: 00000000   edx: 00000000
esi: dde412c0   edi: dde41326   ebp: dd535000   esp: df681e3c
ds: 007b   es: 007b   ss: 0068   preempt: 00000001
Process softirq-tasklet (pid: 8, ti=df681000 task=c147f550 task.ti=df681000)
Stack: dde414e8 00000080 dd53500c e02607b7 00000001 00000000 00000006
dd9f67c0
       dd203840 dd66ea98 00000002 c0124d19 dde412c0 ddec39c0 de0ae800
c0124d45
       de0ae960 e022a7bf de0aeb70 dd6a2004 dd6a2010 00000046 00000000
0000003c
Call Trace:
 [<e02607b7>] rx_mgmt+0x80/0x113a [at76_usb]
 [<c0124d19>] __queue_work+0x54/0x5e
 [<c0124d45>] queue_work+0x22/0x2b 
 [<e022a7bf>] ipw_rx_queue_restock+0xa6/0xb9 [ipw2200]
 [<c011b6cf>] irq_exit+0x40/0x62
 [<c0105366>] do_IRQ+0xa3/0xbd 
 [<e02600e1>] submit_rx_urb+0x1d6/0x26f [at76_usb]
 [<e02656a7>] rx_tasklet+0x10bc/0x1146 [at76_usb]
 [<c02bccf5>] netlink_broadcast+0x256/0x296
 [<c02bd205>] nlmsg_notify+0x3e/0x66
 [<c011b390>] __tasklet_action+0xe2/0x121
 [<c030d752>] schedule+0xe0/0xfa
 [<c011b79d>] ksoftirqd+0x0/0x14f
 [<c011b86d>] ksoftirqd+0xd0/0x14f
 [<c01275ae>] kthread+0xa0/0xca  
 [<c012750e>] kthread+0x0/0xca   
 [<c0103857>] kernel_thread_helper+0x7/0x10
 =======================
Code: 86 a0 07 00 00 0f af 86 a4 07 00 00 0f b6 5f 01 0f af d8 a1 60 c3 3a
c0 e8 05 cd eb df 89 c2 89 d8 2b 96 a8 07 00 00 89 d1 31 d2 <f7> f1 88 46 66
a1 60 c3 3a c0 e8 e8 cc eb df c7 86 a4 07 00 00
EIP: [<e025dfb7>] update_wstats+0x6c/0xb6 [at76_usb] SS:ESP 0068:df681e3c
 <3>ipw2200: Failed to send SCAN_REQUEST_EXT: Command timed out.
/home/nowhiskey/software/wlan/debian/at76c503a/at76c503.c: wlan0: lost
 beacon bssid 02:ca:ff:ee:ba:be
nowhiskey@murija2:~$



don´t know, but i hope that someone from this list will have any idea of 
what is going on here!
if you need additional information on my system, pleas let me know that.
please keep in mind to put my email address into CC so that i receive 
the post related to this issue.


cheers,
doc
