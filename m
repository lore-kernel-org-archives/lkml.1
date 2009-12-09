Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZLIKig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZLIKig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 05:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZLIKie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 05:38:34 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:43420 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815AbZLIKid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 05:38:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=xq4ZCJXZFfsGQEXhyOv5A+AtWnIubAUA3CgRkesGROtivSu4KVbT5hjM52e0y2+EDl
         EPUXAcKaPNQ/C1lRMtIZ1Jq1KKijreALPhQ425Y+FMa0WfxheiX6kjt/+OPGpf9ncIEF
         QdbraWsRM5b4mXtjbRN7fNg+MYAU8QS8MU+UY=
MIME-Version: 1.0
Date: Wed, 9 Dec 2009 18:38:40 +0800
Message-ID: <2375c9f90912090238u7487019eq2458210aac4b602@mail.gmail.com>
Subject: An mm bug in today's 2.6.32 git tree
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, mm experts,

I met the following bug in the kernel from today's git tree, accidentally.
I don't know how to reproduce it, just saw it twice when doing different
work. Machine is x86_64.

Is this bug known?

Please feel free to let me know if you need more info.

Thanks!

----------------
swap_free: Bad swap offset entry 09003c00
BUG: Bad page map in process vim  pte:1200780000 pmd:22f221067
addr:000000319ce0f000 vm_flags:08000075 anon_vma:(null)
mapping:ffff88022efa8848 index:f
vma->vm_ops->fault: filemap_fault+0x0/0x593
vma->vm_file->f_op->mmap: generic_file_mmap+0x0/0x63
Pid: 659, comm: vim Tainted: G    B      2.6.32 #55
Call Trace:
 [<ffffffff81116d32>] ? print_bad_pte+0x29b/0x2c2
 [<ffffffff81118550>] ? unmap_vmas+0x8bc/0xbd5
 [<ffffffff8111eaf9>] ? exit_mmap+0x13b/0x232
 [<ffffffff810593de>] ? mmput+0x57/0x123
 [<ffffffff8105f8ce>] ? exit_mm+0x1af/0x1c1
 [<ffffffff81089da6>] ? up_read+0x10/0x19
 [<ffffffff81061607>] ? do_exit+0x2f2/0xa61
 [<ffffffff81089da6>] ? up_read+0x10/0x19
 [<ffffffff81061e75>] ? sys_exit_group+0x0/0x24
 [<ffffffff81061e8e>] ? sys_exit_group+0x19/0x24
 [<ffffffff810039ab>] ? system_call_fastpath+0x16/0x1b
