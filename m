Return-Path: <linux-kernel-owner+w=401wt.eu-S934431AbXHGNY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431AbXHGNY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761225AbXHGNYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:24:20 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:28930 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758310AbXHGNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:24:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=DsoTBsvTOkA7rTEk5iGueKsXx5n2VYa9qCUve/YuTlSGuIdI3SMF+H2l12eCGKrbwCHNzPipTIw0h7mJtfM0Tlme9nJH+mSwyTUTgKR/IjzNZYDa7notxxWUdnk+iMvpv5cqTy/hwwxEJMTXQd9DuVlR8Gf77RsbnDT73d6xoLY=
Message-ID: <4727185d0708070624q72f8660bif37074036c1401a5@mail.gmail.com>
Date: Tue, 7 Aug 2007 15:24:17 +0200
From: "Vincent Legoll" <vincent.legoll@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: [PATCH] 2.4.35 compilation failed in LVM
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38222_7453949.1186493057618"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38222_7453949.1186493057618
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I tried to get 2.4.35 to compile on a file server I manage, and got that:

gcc -D__KERNEL__ -I/usr/src/linux-2.4/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing
-fno-common -fno-builtin-sprintf -fomit-frame-pointer
-Wno-pointer-sign -pipe -mpreferred-stack-boundary=2 -march=i686
-fno-unit-at-a-time -DMODULE -DMODVERSIONS -include
/usr/src/linux-2.4/include/linux/modversions.h  -nostdinc -iwithprefix
include -DKBUILD_BASENAME=lvm  -c -o lvm.o lvm.c
lvm.c:397: error: static declaration of 'vg_count' follows non-static
declaration
lvm-internal.h:48: error: previous declaration of 'vg_count' was here

looking in the 2.4.35 patch, this has been modified, is there already
a fix for that ?

Reverting the attached patch hunk fixed the compilation for me...

-- 
Vincent Legoll

------=_Part_38222_7453949.1186493057618
Content-Type: application/octet-stream; name=patch-fix-lvm-compil
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f52f3ogh
Content-Disposition: attachment; filename="patch-fix-lvm-compil"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvbHZtLWludGVybmFsLmggYi9kcml2ZXJzL21kL2x2bS1p
bnRlcm5hbC5oCmluZGV4IGFjYTg2MzIuLmY5NTA2OWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQv
bHZtLWludGVybmFsLmgKKysrIGIvZHJpdmVycy9tZC9sdm0taW50ZXJuYWwuaApAQCAtNDUsNiAr
NDUsNyBAQCBleHRlcm4gaW50IGxvYWR0aW1lOwogZXh0ZXJuIGNvbnN0IGNoYXIgKmNvbnN0IGx2
bV9uYW1lOwogCiAKK2V4dGVybiB1aW50IHZnX2NvdW50OwogZXh0ZXJuIHZnX3QgKnZnW107CiBl
eHRlcm4gc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBsdm1fY2hyX2ZvcHM7CiAK
------=_Part_38222_7453949.1186493057618--
