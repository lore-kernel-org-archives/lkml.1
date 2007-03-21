Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbXCUUiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbXCUUiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934000AbXCUUiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:38:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:28708 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbXCUUiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Z45d1PlHzqXFSBccZq4pHVc40rFmsqkkjvQVr/W4awMNpLGg+cEHty5+0Vh2cKzQLweXMUH85SEgsf0KlJSKcm5sjVS1kH4SzuYBaKkXD8mbMl7kE0hDDjiYK/7+Th4iU8i1NXj9j19cuq5UB9Rs7IhaEt0fmr8GjBVasjLS5uk=
Message-ID: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com>
Date: Wed, 21 Mar 2007 21:38:48 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: 2.6.21-rc4-rt0 BUG: at kernel/fork.c:1033 copy_process()
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

It might be lockdep related

-#ifdef CONFIG_TRACE_IRQFLAGS
+#if defined(CONFIG_TRACE_IRQFLAGS) && defined(CONFIG_LOCKDEP)

BUG: at kernel/fork.c:1033 copy_process()
 [<c0105474>] dump_trace+0x78/0x21a
 [<c010564b>] show_trace_log_lvl+0x35/0x54
 [<c0105ddc>] show_trace+0x2c/0x2e
 [<c0105ea3>] dump_stack+0x29/0x2b
 [<c01234e0>] copy_process+0x1d1/0x1440
 [<c01249fc>] do_fork+0xa8/0x18f
 [<c010239e>] kernel_thread+0x93/0x99
 [<c01393ec>] keventd_create_kthread+0x2f/0x7c
 [<c01394ae>] kthread_create+0x75/0xbb
 [<c011feba>] migration_call+0x5c/0x3cf
 [<c04ddb54>] migration_init+0x2b/0x62
  [<c04d14c5>] init+0x56/0x361
 [<c0104ffb>] kernel_thread_helper+0x7/0x10
 =======================
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/rt-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc4-rt0/rt-dmesg

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
