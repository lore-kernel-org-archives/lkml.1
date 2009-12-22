Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZLVU0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZLVU0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 15:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbZLVU0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 15:26:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:61513 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZLVU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 15:26:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=TEohF62udTjl5j8H9jSvhWHfRNXXKpKJKzdvsvdQLw7ASjS0Hxn4cO5PgSMz3Cc1Fn
         6XHEx1HOY3LL6Ok9PqymmNHpEfbX1fgy+KbKJhHBCYC60jWnvNuvUnZf/xoG4kR8yDf6
         qNnGeAcGxgu/j0Uj3M4V1abLSk/KWIsD6y6VY=
MIME-Version: 1.0
Date: Tue, 22 Dec 2009 15:26:11 -0500
Message-ID: <b3eb0ed40912221226o56e4de26oc3119f3b0a946548@mail.gmail.com>
Subject: Oops in 2.6.27.39 with latest DTrace linux port
From: Soumendu Satapathy <satapathy.soumendu@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nBMKQt16005980

Hi,
http://lkml.org/lkml/2009/12/22/219
Attaching the patch for the above:-
--- driver/dtrace_linux.c.orig  2009-12-22 20:15:10.116371000 +0000+++ driver/dtrace_linux.c       2009-12-22 20:17:03.248172000 +0000@@ -1450,7 +1450,18 @@ //             printk("yy: pmd=%lx\n", *pmd);                return 0;        }-       pte = pte_offset_kernel(pmd, addr);++       if (pmd_large(*pmd)) {+                pte = (pte_t *)pmd;+        }+        else {++                pte = pte_offset_kernel(pmd, addr);+        }++        if (pte_none(*pte))+                return 0;+        if (dump_tree) {                printk("yy -- begin\n");                print_pte((pte_t *) pgd, 0);


- Soumendu sekhar satapathyÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
