Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYA1SHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYA1SHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYA1SGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:06:54 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:32875 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYA1SGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:06:52 -0500
Message-ID: <479E19C9.7020201@keyaccess.nl>
Date: Mon, 28 Jan 2008 19:07:05 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trenn@suse.de
CC: Pekka Enberg <penberg@cs.helsinki.fi>, linux-acpi@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>, Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH] Allocate pnp resources dynamically via krealloc	-	working
 version - Addon patch 1
References: <1200772810.3708.42.camel@queen>	 <84144f020801191623i2ad344a8t1c40969578793d13@mail.gmail.com>	 <1201109917.20940.214.camel@queen.suse.de> <479CD935.3070906@keyaccess.nl>	 <1201530103.20940.413.camel@queen.suse.de> <479DEE10.6060203@keyaccess.nl> <1201536284.20940.424.camel@queen.suse.de>
In-Reply-To: <1201536284.20940.424.camel@queen.suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.6 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28-01-08 17:04, Thomas Renninger wrote:

> Can you try these two "on top" patches pls.

Thought I could, but my machine begs to differ...

===
pnp: the driver 'cs4236_isapnp' has been registered
cs4236_isapnp 01:01.00: driver attached
cs4236_isapnp 01:01.02: driver attached
cs4236_isapnp 01:01.03: driver attached
BUG: unable to handle kernel NULL pointer dereference at virtual address 
0000000f
printing eip: c10e5136 *pde = 00000000
Oops: 0000 [#1] PREEMPT
Modules linked in: snd_cs4236 snd_opl3_lib snd_hwdep snd_cs4236_lib 
snd_mpu401_uart snd_rawmidi snd_seq_device snd_cs4231_lib snd_pcm snd_timer 
snd_page_alloc snd soundcore nfsd lockd nfs_acl sunrpc exportfs

Pid: 1370, comm: modprobe Not tainted (2.6.24-local #5)
EIP: 0060:[<c10e5136>] EFLAGS: 00010246 CPU: 0
EIP is at pnp_assign_port+0x1d/0xd5
EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
ESI: ef8fe100 EDI: ef8f5800 EBP: 00000000 ESP: ed3b4e08
  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process modprobe (pid: 1370, ti=ed3b4000 task=ed35c000 task.ti=ed3b4000)
Stack: ed3b4e34 c108ac94 ed3b4e34 ed3c1b10 00000000 efa4e360 c108b88b ef8fe100
        00000000 ef8f5800 ef82ee40 c10e5360 00000001 ef8f5964 00000000 00000000
        00000000 00000000 00000000 ef805ea0 ef8f5800 ef863c80 00000001 ed373400
Call Trace:
  [<c108ac94>] sysfs_addrm_start+0x36/0x81
  [<c108b88b>] sysfs_create_link+0xd0/0x111
  [<c10e5360>] pnp_assign_resources+0x172/0x23a
  [<c10e548f>] pnp_auto_config_dev+0x67/0xa6
  [<c10e373a>] pnp_request_card_device+0x9b/0xbe
  [<c10e54e1>] pnp_activate_dev+0x13/0x3a
  [<f0a4b559>] snd_cs423x_pnpc_detect+0xe4/0x35f [snd_cs4236]
  [<c10e330d>] pnp_alloc+0xe/0x25
  [<c10e3652>] card_probe+0xba/0x107
  [<c10e3b75>] pnp_register_card_driver+0xa3/0xb3
  [<f08de02f>] alsa_card_cs423x_init+0x2f/0x4f [snd_cs4236]
  [<c103258a>] sys_init_module+0x1379/0x149b
  [<c104773a>] unmap_region+0xe5/0x100
  [<c1003d62>] syscall_call+0x7/0xb
  =======================
Code: ba 01 00 00 00 83 c4 1c 89 d0 5b 5e 5f c3 55 89 cd 57 89 c7 56 89 d6 
ba 01 00 00 00 53 6b d9 1c 83 ec 1c 89 d8 03 87 64 01 00 00 <f6> 40 0f 40 0f 
84 a4 00 00 00 8b 00 8b 97 64 01 00 00 0f b6 4e
EIP: [<c10e5136>] pnp_assign_port+0x1d/0xd5 SS:ESP 0068:ed3b4e08
---[ end trace d756fac577a9260d ]---

Rene.
