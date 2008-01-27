Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbYA0TTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbYA0TTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYA0TTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:19:13 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51135 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbYA0TTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:19:12 -0500
Message-ID: <479CD935.3070906@keyaccess.nl>
Date: Sun, 27 Jan 2008 20:19:17 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc -	working
 version
References: <1200772810.3708.42.camel@queen>	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com> <1201109917.20940.214.camel@queen.suse.de>
In-Reply-To: <1201109917.20940.214.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.6 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-01-08 18:38, Thomas Renninger wrote:

> isapnp is totally untested. Also the sysfs is rather untested.

If nobody beats me to it I'll debug this myself later on, but as a quick 
heads up:

pnp: the driver 'cs4236_isapnp' has been registered
cs4236_isapnp 01:01.00: driver attached
cs4236_isapnp 01:01.02: driver attached
cs4236_isapnp 01:01.03: driver attached
pnp: Port resource 0 not allocated, cannot assign value
pnp: Port resource 1 not allocated, cannot assign value
pnp: Port resource 2 not allocated, cannot assign value
pnp: Irq resource 0 not allocated, cannot assign value
pnp: DMA resource 0 not allocated, cannot assign value
pnp: DMA resource 1 not allocated, cannot assign value
BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000000c
printing eip: c10e76d9 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
snd_page_alloc snd soundcore nfsd lockd nfs_acl sunrpc exportfs

Pid: 1353, comm: modprobe Not tainted (2.6.24-local #2)
EIP: 0060:[<c10e76d9>] EFLAGS: 00010246 CPU: 0
EIP is at isapnp_set_resources+0x4d/0x132
EAX: 00000000 EBX: 00000000 ECX: e3c8f000 EDX: 00000000
ESI: 00000000 EDI: ef8f5964 EBP: ef8f5800 ESP: e3c8fe5c
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1353, ti=e3c8f000 task=ed2c2f90 task.ti=e3c8f000)
Stack: ef8f5800 ef8f5888 f0a4e0a4 ed349000 c10e48c8 c10e373a f0a4e0c0 ef8f5800
        ef8f5800 00000000 c10e5101 ef8f5800 f0a4b559 00000286 00000001 f0a4d780
        c10e330d c12b7c6c ef8f5e00 ed37f140 ed3491bc ef8f5e00 ed37f140 f0a4e0a4
Call Trace:
  [<c10e48c8>] pnp_start_dev+0x55/0x9e
  [<c10e373a>] pnp_request_card_device+0x9b/0xbe
  [<c10e5101>] pnp_activate_dev+0x23/0x39
  [<f0a4b559>] snd_cs423x_pnpc_detect+0xe4/0x35f [snd_cs4236]
  [<c10e330d>] pnp_alloc+0xe/0x25
  [<c10e3652>] card_probe+0xba/0x107
  [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
  [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
  [<c103258a>] sys_init_module+0x1379/0x149b
  [<c104773a>] unmap_region+0xe5/0x100
  [<c1003d62>] syscall_call+0x7/0xb
  =======================
Code: ff ff ff c7 85 54 01 00 00 01 00 00 00 eb 18 0f b7 12 8d 44 1b 60 43 
83 c6 1c 0f b6 c0 e8 ce fd ff ff 83 fb 08 74 13 89 f2 03 17 <8b> 42 0c 25 00 
01 00 20 3d 00 01 00 00 74 d5 31 db 31 f6 eb 25
EIP: [<c10e76d9>] isapnp_set_resources+0x4d/0x132 SS:ESP 0068:e3c8fe5c
---[ end trace f836fd70d1d20199 ]---

Rene.
