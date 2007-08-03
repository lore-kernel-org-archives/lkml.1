Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXHCIlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXHCIlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 04:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXHCIln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 04:41:43 -0400
Received: from pointone.de ([81.92.162.26]:3362 "EHLO mail.pointone.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754595AbXHCIlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 04:41:42 -0400
Message-ID: <46B2EA43.8070305@in.tum.de>
Date: Fri, 03 Aug 2007 10:41:39 +0200
From: =?ISO-8859-1?Q?Christian_Sch=E4fer?= <schaefer@in.tum.de>
User-Agent: Thunderbird 2.0.0.5 (X11/20070725)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [BUG] timer.h
References: <46B1F896.8090005@in.tum.de>
In-Reply-To: <46B1F896.8090005@in.tum.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Schäfer wrote:
> today I got the following kernel bug while wpa_supplicant tried to 
> connect to my AP. Kernel is a self-compiled 2.6.22 running under Ubuntu 
> Feisty.
> The wireless device is a r8187 USB, the driver is patched for injection 
> capability taken from www.aircrack-ng.org.
> Don't know if this bug is related to the driver or to the kernel, I'm no 
> expert.
> 
> Attached is the full dmesg and .config. Please CC to me, I'm not on the 
> list.

I was able to reproduce the bug without a tainted kernel (i.e. without 
the nvidia binary module). Please let me know if you need more infos.


------------[ cut here ]------------
kernel BUG at include/linux/timer.h:153!
invalid opcode: 0000 [#1]
PREEMPT
Modules linked in: ieee80211_crypt_wep_rtl ieee80211_crypt_tkip_rtl 
ieee80211_crypt_ccmp_rtl r8187 ieee80211_rtl ieee80211_crypt_rtl 
speedstep_ich speedstep_lib dm_crypt dm_mod fuse firewire_sbp2 ehci_hcd 
ohci_hcd pcmcia firmware_class usbhid firewire_ohci firewire_core 
yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t floppy uhci_hcd usbcore
CPU:    0
EIP:    0060:[<f8e45cf4>]    Not tainted VLI
EFLAGS: 00010286   (2.6.22 #3)
EIP is at ieee80211_associate_step1_rtl7+0x257/0x28d [ieee80211_rtl]
eax: f74cfae8   ebx: c045c030   ecx: f74cfcf8   edx: ffffffff
esi: f74cf3a0   edi: e8fd2e80   ebp: 00000202   esp: f0d5ff68
ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
Process Ieee80211/0 (pid: 2733, ti=f0d5e000 task=f176c0b0 task.ti=f0d5e000)
Stack: ffffffff e9ee0410 f74cfb88 f74cf3a0 f4c6fc40 f8e4600c f8e4606e 
f74cfb8c
        f74cfb88 c01276a6 00000000 00000000 0000001a c0456198 f4c6fc48 
f4c6fc40
        c0127c55 00000000 c0127cf2 00000000 f176c0b0 c012a784 f0d5ffc0 
f0d5ffc0
Call Trace:
  [<f8e4600c>] ieee80211_associate_procedure_wq_rtl7+0x0/0x78 
[ieee80211_rtl]
  [<f8e4606e>] ieee80211_associate_procedure_wq_rtl7+0x62/0x78 
[ieee80211_rtl]
  [<c01276a6>] run_workqueue+0x84/0x135
  [<c0127c55>] worker_thread+0x0/0xfb
  [<c0127cf2>] worker_thread+0x9d/0xfb
  [<c012a784>] autoremove_wake_function+0x0/0x37
  [<c0127c55>] worker_thread+0x0/0xfb
  [<c012a4aa>] kthread+0x33/0x54
  [<c012a477>] kthread+0x0/0x54
  [<c010490f>] kernel_thread_helper+0x7/0x18
  =======================
Code: 51 c7 e9 5b ff ff ff 66 c7 86 c4 05 00 00 00 00 e9 2b ff ff ff 89 
fa 89 f0 e8 b8 c3 ff ff eb c5 66 c7 86 c4 05 00 00 00 00 eb 9d <0f> 0b 
eb fe b9 fd 5c e4 f8 ba 1e 00
  00 00 89 f8 e8 13 ca 4a c7
EIP: [<f8e45cf4>] ieee80211_associate_step1_rtl7+0x257/0x28d 
[ieee80211_rtl] SS:ESP 0068:f0d5ff68




