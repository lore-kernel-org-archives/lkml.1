Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbXFNUYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbXFNUYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbXFNUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:24:28 -0400
Received: from va-65-40-217-47.sta.embarqhsd.net ([65.40.217.47]:13538 "EHLO
	CVAEX1.VERTICAL.COM" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752615AbXFNUY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:24:27 -0400
X-Greylist: delayed 850 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Jun 2007 16:24:27 EDT
Content-class: urn:content-classes:message
Subject: scheduling while atomic on arm board.
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jun 2007 16:10:14 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <4DD3AF7ECBBC43409BA36508938D01851B0E5A@CVAEX1.VERTICAL.COM>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: scheduling while atomic on arm board.
Thread-Index: AceuwALfwqBRyh8pQy+zb77zhD9asg==
From: "Jon Ringle" <JRingle@vertical.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running Linux 2.6.16.29 on an ixp455 based board (arm). On rare
occasions, I am seeing the following stack dump, which gets resolved
only when a power cycle is done. Does anyone have any suggestions on
what to look for?

Thanks,
Jon

[42949427.370000] scheduling while atomic: sh/0x00000002/144
[42949427.380000] [<c0030370>] (dump_stack+0x0/0x14) from [<c029a868>]
(schedule+0x628/0x6c8)
[42949427.390000] [<c029a240>] (schedule+0x0/0x6c8) from [<c029c92c>]
(__down_read+0xc4/0x128)
[42949427.400000] [<c029c868>] (__down_read+0x0/0x128) from [<c00335a4>]
(do_page_fault+0x84/0x214)
[42949427.400000]  r5 = 00000017  r4 = C02F6168
[42949427.410000] [<c0033520>] (do_page_fault+0x0/0x214) from
[<c0033870>] (do_DataAbort+0x3c/0xa4)
[42949427.420000] [<c0033834>] (do_DataAbort+0x0/0xa4) from [<c002a800>]
(__dabt_svc+0x40/0x60)
[42949427.430000]  r8 = 00000093  r7 = C0186920  r6 = E5903048  r5 =
CF21FD14
[42949427.430000]  r4 = FFFFFFFF
[42949427.440000] [<c0034990>] (do_alignment_ldrstr+0x0/0x130) from
[<c0034fac>] (do_alignment+0x238/0x34c)
[42949427.450000]  r4 = CF21E000
[42949427.450000] [<c0034d74>] (do_alignment+0x0/0x34c) from
[<c0033870>] (do_DataAbort+0x3c/0xa4)
[42949427.460000] [<c0033834>] (do_DataAbort+0x0/0xa4) from [<c002a800>]
(__dabt_svc+0x40/0x60)
[42949427.470000]  r8 = CFD51F34  r7 = 80000000  r6 = 00000001  r5 =
CF21FE58
[42949427.470000]  r4 = FFFFFFFF
[42949427.480000] [<c0186900>] (get_index+0x0/0x5c) from [<c0186bd0>]
(prio_tree_insert+0xac/0x28c)
[42949427.490000] [<c0186b24>] (prio_tree_insert+0x0/0x28c) from
[<c00762f8>] (vma_prio_tree_insert+0x28/0x40)
[42949427.500000] [<c00762d0>] (vma_prio_tree_insert+0x0/0x40) from
[<c007b80c>] (vma_link+0xe0/0x1d4)
[42949427.500000]  r5 = CFC4F90C  r4 = CF21E000
[42949427.510000] [<c007b72c>] (vma_link+0x0/0x1d4) from [<c007cfe8>]
(do_mmap_pgoff+0x390/0x760)
[42949427.520000]  r7 = CFC374E0  r6 = 00001000  r5 = 4005E000  r4 =
CFC4F90C
[42949427.520000] [<c007cc58>] (do_mmap_pgoff+0x0/0x760) from
[<c002f64c>] (old_mmap+0x108/0x130)
[42949427.530000] [<c002f544>] (old_mmap+0x0/0x130) from [<c002aca0>]
(ret_fast_syscall+0x0/0x2c)
