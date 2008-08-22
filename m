Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYHVOzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYHVOzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 10:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbYHVOyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 10:54:54 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63852 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbYHVOyx (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 10:54:53 -0400
Date: Fri, 22 Aug 2008 16:54:51 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
In-Reply-To: <48AD00C4.6060302@gmail.com>
Message-ID: <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
References: <48AD00C4.6060302@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-487481057-1219416891=:17105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-487481057-1219416891=:17105
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi Jared,

On Wed, 20 Aug 2008, Jared Hulbert wrote:
> I'd like to get a first round of review on my AXFS filesystem.  This is a simple

> See http://axfs.sourceforge.net for more info.

The version in SVN seems to be slightly older than the one you submitted?

Which platform(s) do you use for testing?

I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing new
code ;-).
When mounting the image, I got the crash below:

| attempt to access beyond end of device
| loop0: rw=0, want=4920, limit=4912
| Unable to handle kernel paging request for data at address 0x00000028
| Faulting instruction address: 0xd000000000037988
| Oops: Kernel access of bad area, sig: 11 [#1]
| SMP NR_CPUS=2 PS3
| Modules linked in: axfs zlib_inflate nfsd exportfs dm_crypt dm_mod sg joydev evdev
| NIP: d000000000037988 LR: d000000000037974 CTR: 0000000000000000
| REGS: c00000000c1e3240 TRAP: 0300   Not tainted  (2.6.27-rc4-dirty)
| MSR: 8000000000008032 <EE,IR,DR>  CR: 24044482  XER: 20000000
| DAR: 0000000000000028, DSISR: 0000000040000000
| TASK = c0000000068d4e40[1744] 'mount' THREAD: c00000000c1e0000 CPU: 0
| GPR00: d000000000037974 c00000000c1e34c0 d000000000043f30 c00000000c1e36a0 
| GPR04: 000000000000013e 000000000000013e c00000000c1e2eb0 0000000000000002 
| GPR08: c00000000058de80 0000000000000001 c0000000068d4e40 c00000000c1e34c0 
| GPR12: 8000000000008032 c000000000671300 0000000010020000 00000000ff80bec1 
| GPR16: 0000000010023dc8 0000000010023db8 00000000ff80bed1 0000000010023e00 
| GPR20: 0000000000000001 0000000010023e38 c00000000c1e36a0 c00000000c1d5000 
| GPR24: 0000000000000000 0000000000000004 0000000000266000 0000000000000000 
| GPR28: 0000000000001000 0000000000000004 d0000000000438e0 c00000000c1e34c0 
| NIP [d000000000037988] .axfs_copy_block+0xa0/0x144 [axfs]
| LR [d000000000037974] .axfs_copy_block+0x8c/0x144 [axfs]
| Call Trace:
| [c00000000c1e34c0] [d000000000037974] .axfs_copy_block+0x8c/0x144 [axfs] (unreliable)
| [c00000000c1e3580] [d000000000035f20] .axfs_copy_metadata+0x154/0x1cc [axfs]
| [c00000000c1e3630] [d000000000035fd8] .axfs_verify_eofs_magic+0x40/0xa0 [axfs]
| [c00000000c1e36c0] [d000000000036678] .axfs_fill_super+0x3c0/0x7c8 [axfs]
| [c00000000c1e3780] [c0000000000d1670] .get_sb_bdev+0x154/0x1ec
| [c00000000c1e3860] [d000000000037a94] .axfs_get_sb_bdev+0x34/0x6c [axfs]
| [c00000000c1e38f0] [d000000000035d0c] .axfs_get_sb+0x320/0x394 [axfs]
| [c00000000c1e3a00] [c0000000000d1318] .vfs_kern_mount+0x88/0x108
| [c00000000c1e3ab0] [c0000000000d143c] .do_kern_mount+0x68/0x148
| [c00000000c1e3b60] [c0000000000f0a10] .do_new_mount+0x90/0xf4
| [c00000000c1e3c10] [c0000000000f0c5c] .do_mount+0x1e8/0x23c
| [c00000000c1e3d60] [c000000000114778] .compat_sys_mount+0x21c/0x2ac
| [c00000000c1e3e30] [c0000000000074dc] syscall_exit+0x0/0x40
| Instruction dump:
| 3b600000 409e0084 48000090 80b7001c e87701d0 7c84e392 48000799 e8410028 
| 2fbb0000 7c781b78 7f3de040 7ec3b378 <e8980028> 409e002c 7f3dcb78 7c1ae392 
| ---[ end trace 7f5bc7e7ad0c4386 ]---

When mounting (also on PS3) an image created on ia32, I get a different crash:

| axfs: wrong magic
  ^^^^^^^^^^^^^^^^^
| Unable to handle kernel paging request for data at address 0x000003a8
| Faulting instruction address: 0xd0000000000355f0
| Oops: Kernel access of bad area, sig: 11 [#1]
| SMP NR_CPUS=2 PS3
| Modules linked in: axfs zlib_inflate nfsd exportfs dm_crypt dm_mod sg joydev evdev
| NIP: d0000000000355f0 LR: c0000000000d1250 CTR: d0000000000355d0
| REGS: c00000000c0b73d0 TRAP: 0300   Not tainted  (2.6.27-rc4-dirty)
| MSR: 8000000000008032 <EE,IR,DR>  CR: 24044482  XER: 00000000
| DAR: 00000000000003a8, DSISR: 0000000040000000
| TASK = c000000006814b40[1745] 'mount' THREAD: c00000000c0b4000 CPU: 1
| GPR00: c0000000000d1250 c00000000c0b7650 d000000000043f30 c00000000652f800 
| GPR04: c00000000652f8b8 c000000006815480 0000000000000002 c000000006815480 
| GPR08: c000000006815480 0000000000000000 00000000000001ea 0000000000000000 
| GPR12: d000000000037e68 c000000000671500 0000000010020000 00000000ffc18eee 
| GPR16: 0000000010023d98 0000000010023d88 00000000ffc18efe 0000000010023db0 
| GPR20: 0000000000000001 0000000010023dc8 c00000000634f280 c0000000065b5000 
| GPR24: fffffffffffff000 d00000000003bd38 0000000000000000 d00000000003b278 
| GPR28: c00000000652f800 c00000000652f800 c0000000005d66e8 c00000000c0b7650 
| NIP [d0000000000355f0] .axfs_kill_super+0x20/0x9c [axfs]
| LR [c0000000000d1250] .deactivate_super+0xd4/0x114
| Call Trace:
| [c00000000c0b7650] [c0000000003d2c48] .down_write+0x5c/0xb8 (unreliable)
| [c00000000c0b76e0] [c0000000000d1250] .deactivate_super+0xd4/0x114
| [c00000000c0b7780] [c0000000000d1690] .get_sb_bdev+0x174/0x1ec
| [c00000000c0b7860] [d000000000037a94] .axfs_get_sb_bdev+0x34/0x6c [axfs]
| [c00000000c0b78f0] [d000000000035d0c] .axfs_get_sb+0x320/0x394 [axfs]
| [c00000000c0b7a00] [c0000000000d1318] .vfs_kern_mount+0x88/0x108
| [c00000000c0b7ab0] [c0000000000d143c] .do_kern_mount+0x68/0x148
| [c00000000c0b7b60] [c0000000000f0a10] .do_new_mount+0x90/0xf4
| [c00000000c0b7c10] [c0000000000f0c5c] .do_mount+0x1e8/0x23c
| [c00000000c0b7d60] [c000000000114778] .compat_sys_mount+0x21c/0x2ac
| [c00000000c0b7e30] [c0000000000074dc] syscall_exit+0x0/0x40
| Instruction dump:
| f9240030 ebebfff0 7d615b78 4e800020 f821ff71 7c0802a6 fba10078 7c7d1b78 
| fbe10088 7c3f0b78 f80100a0 e9230470 <e80903a8> 2fa00000 409e0034 e80301d8 
| ---[ end trace c19667cc5b6821ab ]---

So I guess some parts are not yet 64-bit or endian clean.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-487481057-1219416891=:17105--
