Return-Path: <linux-kernel-owner+w=401wt.eu-S932974AbXFFMnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbXFFMnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 08:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764217AbXFFMnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 08:43:06 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:26528 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934347AbXFFMnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 08:43:05 -0400
Message-ID: <4666ABD4.8050402@fr.ibm.com>
Date: Wed, 06 Jun 2007 14:43:00 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

When CONFIG_DEBUG_VM=y, boot on i386 and s390 (the only one tested) ends 
with the following. 

C.
 
------------[ cut here ]------------
kernel BUG at mm/rmap.c:557!
invalid opcode: 0000 [#1]
CPU:    0
EIP:    0060:[<c013cbbd>]    Not tainted VLI
EFLAGS: 00000206   (2.6.22-rc4-mm1 #1)
EIP is at __page_check_anon_rmap+0x21/0x28
eax: c15bd431   ebx: c1024700   ecx: 000bffa6   edx: c15bb6d0
esi: c1024700   edi: 01238045   ebp: c1423e9c   esp: c1423e98
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process init (pid: 1, ti=c1422000 task=c14216b0 task.ti=c1422000)
Stack: c1024700 c1423ea8 c013d631 01238045 c1423ef8 c01392a6 c15bb6d0 c15afc40 
       c15afa40 c15aebfc c15c3bfc bffa7000 bffa6000 bffa7000 c15bae98 c15d5e98 
       00000000 c15afa90 c15afc90 00000000 00000002 c15d66f0 00000000 c15bb6d0 
Call Trace:
 [<c010282d>] show_trace_log_lvl+0x1a/0x2f
 [<c01028dd>] show_stack_log_lvl+0x9b/0xa3
 [<c0102a94>] show_registers+0x1af/0x280
 [<c0102c4b>] die+0xe6/0x1e5
 [<c0102dd3>] do_trap+0x89/0xa2
 [<c010313e>] do_invalid_op+0x88/0x92
 [<c024d142>] error_code+0x6a/0x70
 [<c013d631>] page_dup_rmap+0x1b/0x21
 [<c01392a6>] copy_page_range+0x22b/0x2d0
 [<c01109bc>] copy_process+0x964/0xf54
 [<c01110d1>] do_fork+0x98/0x1b8
 [<c0100716>] sys_clone+0x33/0x39
 [<c010226c>] syscall_call+0x7/0xb
 =======================
Code: 2a c0 ff 05 30 67 2f c0 5d c3 55 89 e5 53 89 c3 8b 42 3c 40 39 43 10 74 04 0f 0b eb fe 2b 4a 04 c1 e9 0c 03 4a 44 39 4b 14 74 04 <0f> 0b eb fe 5b 5d c3 55 89 e5 53 89 c3 8b 42 3c 85 c0 75 04 0f 
EIP: [<c013cbbd>] __page_check_anon_rmap+0x21/0x28 SS:ESP 0068:c1423e98
Kernel panic - not syncing: Attempted to kill init!
