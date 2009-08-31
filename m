Return-Path: <linux-kernel-owner+w=401wt.eu-S1751657AbZHaKCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657AbZHaKCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZHaKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:02:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40108 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbZHaKCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:02:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:00:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 0/8][mmotm] kcore clean-up and enhance (retry).
Message-Id: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry for messes previous version. This is renewed one onto mmotm-Aug27.

Changes from prerious one are
 - merged compile fix etc. 
 - support module's vaddr range
 - support vmemmap.

Following is kcore's program header. after this patch applied.
This x86-64 host's memory layout is
[root@bluextal mmotm-2.6.31-Aug27]# grep RAM /proc/iomem
00010000-0009e7ff : System RAM
00100000-bfedffff : System RAM
bff00000-bff7ffff : System RAM
100000000-63fffffff : System RAM

Kcore header is.
[root@bluextal mmotm-2.6.31-Aug27]# readelf -l /proc/kcore | grep LOAD
  LOAD           0x00007fffff602000 0xffffffffff600000 0x0000000000000000 (0)
  LOAD           0x00007fff8100b000 0xffffffff81009000 0x0000000000000000 (1)
  LOAD           0x0000490000002000 0xffffc90000000000 0x0000000000000000 (2)
  LOAD           0x00007fffa0002000 0xffffffffa0000000 0x0000000000000000 (3)
  LOAD           0x0000080000012000 0xffff880000010000 0x0000000000000000 (4)
  LOAD           0x00006a0000002000 0xffffea0000000000 0x0000000000000000 (5)
  LOAD           0x0000080000102000 0xffff880000100000 0x0000000000000000 (6)
  LOAD           0x00006a0000008000 0xffffea0000006000 0x0000000000000000 (7)
  LOAD           0x00000800bff02000 0xffff8800bff00000 0x0000000000000000 (8)
  LOAD           0x00006a0004dfb000 0xffffea0004df9000 0x0000000000000000 (9)
  LOAD           0x0000080100002000 0xffff880100000000 0x0000000000000000 (10)
  LOAD           0x00006a0006802000 0xffffea0006800000 0x0000000000000000 (11)

(0) is NOTE section.
(1) is text.
(2) is VMALLOC area
(3) is MODULE area
(4)(6)(8)(10) is physical memory
(5)(7)(9)(11) is vmemmap for ranges.

Thanks,
-Kame


