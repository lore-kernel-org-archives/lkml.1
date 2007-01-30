Return-Path: <linux-kernel-owner+w=401wt.eu-S932831AbXA3LB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831AbXA3LB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 06:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbXA3LB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 06:01:57 -0500
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:1650 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbXA3LB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 06:01:56 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 06:01:55 EST
Message-ID: <45BF2418.9010002@ribosome.natur.cuni.cz>
Date: Tue, 30 Jan 2007 11:55:20 +0100
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2pre) Gecko/20070130 SeaMonkey/1.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.19.1: kernel BUG at mm/slab.c:2911!
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  is this a known issue? Should I bother to upgrade to 2.6.19.2 if it contains the fix?
Thank you any help. It might be related to NFS. The machine in question is NFSv3 client,
udp. And used for computations. The process which died is from torque cluster management
package.
 Please Cc: me in replies. Thanks.
Martin


slab: Internal list corruption detected in cache 'size-32'(84), slabp f3caf080(-2). Hexdump:

000: 00 00 00 00 fe ff ff ff fe ff ff ff 3a 00 00 00
010: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
020: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
030: fe ff ff ff 06 00 00 00 fe ff ff ff fe ff ff ff
040: fe ff ff ff fe ff ff ff 19 00 00 00 fe ff ff ff
050: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
060: 1c 00 00 00 3d 00 00 00 32 00 00 00 fe ff ff ff
070: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
080: fe ff ff ff 3b 00 00 00 2b 00 00 00 fe ff ff ff
090: 31 00 00 00 fe ff ff ff fe ff ff ff fe ff ff ff
0a0: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
0b0: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
0c0: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
0d0: fe ff ff ff fe ff ff ff fe ff ff ff fe ff ff ff
0e0: fe ff ff ff fe ff ff ff fe ff ff ff 71 f0 2c 5a
0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5
110: 71 f0 2c 5a 6d ec 14 c0 71 f0 2c 5a 6b 6b 6b 6b
120: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
130: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 71 f0 2c 5a
140: 6d ec 14 c0 a5 c2 0f 17 70 fc ca f3 fc f2 ca f3
150: 00 00 00 00 00 c0 2d f5 01 00 00 00 ff ff ff ff
160: 00 00 5a 5a fe ff ff ff a5 c2 0f 17
------------[ cut here ]------------
kernel BUG at mm/slab.c:2911!
invalid opcode: 0000 [#1]
DEBUG_PAGEALLOC
Modules linked in:
CPU:    0
EIP:    0060:[<c014fc45>]    Not tainted VLI
EFLAGS: 00010092   (2.6.19.1 #2)
EIP is at check_slabp+0xa0/0xb0
eax: 00000001   ebx: 0000016c   ecx: 00000000   edx: f470de04
esi: f3caf080   edi: c20ff080   ebp: f5753db4   esp: f5753d94
ds: 007b   es: 007b   ss: 0068
Process pbs_mom (pid: 5741, ti=f5752000 task=f5b86ae0 task.ti=f5752000)
Stack: c041c935 00000017 00000054 f3caf080 fffffffe 0000000b f3caf000 c20fd854 
       f5753dd8 c014fd06 c2101ef8 00000004 000000d0 c20ff080 c20ff080 00000246 
       000000d0 f5753df4 c015015e c20fc540 c014f579 00000000 f3f32000 c20fc540 
Call Trace:
 [<c014fd06>] cache_alloc_refill+0xb1/0x1a7
 [<c015015e>] kmem_cache_alloc+0x49/0x67
 [<c014f579>] alloc_slabmgmt+0x1a/0x47
 [<c014f910>] cache_grow+0xbf/0x12f
 [<c014fdc2>] cache_alloc_refill+0x16d/0x1a7
 [<c015015e>] kmem_cache_alloc+0x49/0x67
 [<c0153b7a>] get_empty_filp+0x4e/0xd8
 [<c01598cc>] __path_lookup_intent_open+0x17/0x75
 [<c015994b>] path_lookup_open+0x21/0x27
 [<c015a075>] open_namei+0x76/0x4ae
 [<c0152412>] do_filp_open+0x26/0x3b
 [<c015267c>] do_sys_open+0x45/0xcd
 [<c015271e>] sys_open+0x1a/0x1c
 [<c0102b4d>] sysenter_past_esp+0x56/0x79
 [<b7fd8410>] 0xb7fd8410
 =======================
Code: 3f 3f c0 e8 b2 d2 fc ff 0f b6 04 1e c7 04 24 16 95 41 c0 43 89 44 24 04 e8 9d d2 fc ff eb c6 c7 04 24 35 c9 41 c0 e8 8f d2 fc ff <0f> 0b 5f 0b 1b 3a 3f c0 83 c4 14 5b 5e 5f 5d c3 55 89 e5 57 56 
EIP: [<c014fc45>] check_slabp+0xa0/0xb0 SS:ESP 0068:f5753d94
 
$ uname -a
Linux phylo1 2.6.19.1 #2 Wed Dec 20 21:24:45 CET 2006 i686 Intel(R) Pentium(R) 4 CPU 3.00GHz GNU/Linux
$ 
