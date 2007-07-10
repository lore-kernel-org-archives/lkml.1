Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbXGJOA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbXGJOA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 10:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbXGJOAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 10:00:49 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:18966 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbXGJOAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 10:00:49 -0400
Message-ID: <46939045.5070508@sw.ru>
Date: Tue, 10 Jul 2007 17:57:25 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Ashok Raj <ashok.raj@intel.com>, Shaohua Li <shaohua.li@intel.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>
Subject: OOPS at dmar_table_init (2.6.22-rc6-mm1 kernel)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

While working with Andrew's kernel I faced an OOPS on x86_64 
machine. Unfortunately kernel logs are not appearing in serial 
console by the time oops happens, but I have some info on the
screen:

OOPs is at dmar_table_init() here:
ffffffff80532873 <dmar_table_init>:
ffffffff80532873:       41 55                   push   %r13
ffffffff80532875:       41 54                   push   %r12
ffffffff80532877:       55                      push   %rbp
ffffffff80532878:       53                      push   %rbx
ffffffff80532879:       51                      push   %rcx
ffffffff8053287a:       4c 8b 2d 07 21 01 00    mov    73991(%rip),%r13        # ffffffff80544988 <dmar_tbl>
ffffffff80532881:       41 0f b6 45 24          movzbl 0x24(%r13),%eax  <<<<<<<<<<< OOPS, %r13 = NULL
ffffffff80532886:       84 c0                   test   %al,%al
ffffffff80532888:       75 11                   jne    ffffffff8053289b <dmar_table_init+0x28>
ffffffff8053288a:       48 c7 c7 b0 3d 45 80    mov    $0xffffffff80453db0,%rdi
ffffffff80532891:       e8 c2 4a cf ff          callq  ffffffff80227358 <printk>
ffffffff80532896:       e9 f2 01 00 00          jmpq   ffffffff80532a8d <dmar_table_init+0x21a>

Looks like dmar_tbl is NULL. 
BUG is 100% reproducible. Is there any other info that can be useful?

Thanks,
Pavel
