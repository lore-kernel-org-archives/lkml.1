Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXBRR6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXBRR6R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 12:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbXBRR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 12:58:17 -0500
Received: from aa013msr.fastwebnet.it ([85.18.95.73]:42798 "EHLO
	aa013msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXBRR6Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 12:58:16 -0500
Date: Sun, 18 Feb 2007 18:58:05 +0100
From: Mattia Dongili <malattia@linux.it>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk
Subject: Re: 2.6.20-mm2: Oops in generic_make_request
Message-ID: <20070218175805.GB5567@inferi.kami.home>
Mail-Followup-To: Laurent Riffard <laurent.riffard@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, axboe@kernel.dk
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <45D84F73.8060904@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <45D84F73.8060904@free.fr>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-mm2-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 02:06:59PM +0100, Laurent Riffard wrote:
> Le 18.02.2007 06:51, Andrew Morton a écrit :
> >Temporarily at
> >
> >  http://userweb.kernel.org/~akpm/2.6.20-mm2/
> >
> >Will appear later at
> >
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> 
> Hello, I've got a fully reproducible Oops. I just have to boot to 
> runlevel 2 and wait less than one minute.

Maybe this oops is related too?
Can't yet tell if it's easily reproducible, this is on a JFS filesystem.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000004
 printing eip:
c02206aa
*pde = 00000000
Oops: 0000 [#1]
PREEMPT 
last sysfs file: /devices/pci0000:00/0000:00:00.0/class
CPU:    0
EIP:    0060:[<c02206aa>]    Not tainted VLI
EFLAGS: 00010297   (2.6.20-mm2-1 #1)
EIP is at __make_request+0x13a/0x390
eax: ffffffff   ebx: 00000000   ecx: 042b0dd8   edx: 00010485
esi: c5f8cea0   edi: cfd587f8   ebp: c653dadc   esp: c653dabc
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process sh (pid: 4549, ti=c653c000 task=ccca2090 task.ti=c653c000)
Stack: c137eae8 00000001 cfd587e4 c5f8cea0 c5f893e4 c137eae8 c5f8cea0 00000008 
       c653db28 c021e0ca cfa3ffa0 cee6a2e0 cfa3ffa0 00000000 00000008 00000100 
       00011250 cfedaf60 c653db10 00000206 00000000 c653db18 c014a31e c653db48 
Call Trace:
 [<c01048ba>] show_trace_log_lvl+0x1a/0x30
 [<c0104979>] show_stack_log_lvl+0xa9/0xd0
 [<c0104ba6>] show_registers+0x206/0x350
 [<c0104dfe>] die+0x10e/0x210
 [<c0114652>] do_page_fault+0x2d2/0x600
 [<c0351f84>] error_code+0x74/0x7c
 [<c021e0ca>] generic_make_request+0x15a/0x200
 [<c0220318>] submit_bio+0x58/0xe0
 [<c0205d0f>] metapage_writepage+0x18f/0x1b0
 [<c014cc2b>] __writepage+0xb/0x30
 [<c014d20f>] write_cache_pages+0x22f/0x300
 [<c014d303>] generic_writepages+0x23/0x30
 [<c014d36c>] do_writepages+0x5c/0x60
 [<c0148307>] __filemap_fdatawrite_range+0x67/0x80
 [<c0149785>] filemap_flush+0x25/0x30
 [<c02080cd>] lmLogSync+0x19d/0x230
 [<c020871e>] lmLog+0x5e/0x190
 [<c020a360>] txCommit+0x8c0/0x1010
 [<c01eecf4>] jfs_create+0x324/0x370
 [<c016f38f>] vfs_create+0xaf/0x100
 [<c017269c>] open_namei+0x58c/0x640
 [<c0165b7c>] do_filp_open+0x2c/0x50
 [<c0165be7>] do_sys_open+0x47/0xe0
 [<c0165cbc>] sys_open+0x1c/0x20
 [<c01041c0>] syscall_call+0x7/0xb
 =======================
Code: 5d c3 8b 58 18 8b 43 04 0f 18 00 90 8b 7d e8 83 c7 14 39 fb 75 2
4 e9 2d ff ff ff 8d b6 00 00 00 00 48 0f 84 d9 00 00 00 8b 5b 04 <8b> 43 04 0f 18 00 90 39 fb 0f 84
0e ff ff ff 89 f2 89 d8 e8 2e 
EIP: [<c02206aa>] __make_request+0x13a/0x390 SS:ESP 0068:c653dabc

-- 
mattia
:wq!
