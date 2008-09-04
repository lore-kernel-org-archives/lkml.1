Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbYIDTO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbYIDTO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYIDTOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:14:47 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:18433 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYIDTOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:14:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=egBarg4mAyXbXqtPAfJi84k/LtSaAFbrDMoWpZ1TeFSNm5inKcYGlubR2ukfCJe0+H
         egcRyB3rCrsK5DHswNfVYFSa0a+xZuGtQaml/NqZh/AACImJc45rfCs+k7cxzmJv7S20
         v3Muij8duVlIjlWKmBKS//G6Zd2gk1KK28Qic=
Date: Thu, 4 Sep 2008 21:14:03 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: oops during unmount - ext3? (2.6.27-rc5)
Message-ID: <20080904191356.GA7799@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
2 days ago 2.6.27-rc5 oopsed on halt with this call trace:

dispose_list
invalidate_inodes
generic_shutdown_super
kill_block_super
? deactivate_super
mntput_no_expire
sys_umount
system_call_fastpath

Code: f8 ff 48 89 df e8 bd 19 01 00 48 83 bb 90 02 00 00 00 74 04 0f 0b eb fe 48 8b 83 b8 03 00 00 a8 20 75 04 0f 0b eb fe a8 40 74 04 <0f> 0b eb fe 48 c7 c7 7a a0 57 80 be 56 00 00 00 e8 56 31 f8 ff

RIP clear_inode

Output of decodecode:
/tmp/tmp.To8z8HQ0uE.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   f8                      clc
   1:   ff 48 89                decl   -0x77(%rax)
   4:   df e8                   fucomip %st(0),%st
   6:   bd 19 01 00 48          mov    $0x48000119,%ebp
   b:   83 bb 90 02 00 00 00    cmpl   $0x0,0x290(%rbx)
  12:   74 04                   je     0x18
  14:   0f 0b                   ud2a
  16:   eb fe                   jmp    0x16
  18:   48 8b 83 b8 03 00 00    mov    0x3b8(%rbx),%rax
  1f:   a8 20                   test   $0x20,%al
  21:   75 04                   jne    0x27
  23:   0f 0b                   ud2a
  25:   eb fe                   jmp    0x25
  27:   a8 40                   test   $0x40,%al
  29:   74 04                   je     0x2f

/tmp/tmp.To8z8HQ0uE.o:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:   0f 0b                   ud2a
   2:   eb fe                   jmp    0x2
   4:   48 c7 c7 7a a0 57 80    mov    $0xffffffff8057a07a,%rdi
   b:   be 56 00 00 00          mov    $0x56,%esi
  10:   e8 56 31 f8 ff          callq  0xfffffffffff8316b

You can see partial screenshot and .config at http://www.kadu.net/~joi/kernel/2008.09.04/

It might be related to http://lkml.org/lkml/2008/9/3/405 - I'm not sure.
2 bugs related to VFS and/or ext3 in 2 days (I'm running .27 since rc1)

Marcin
