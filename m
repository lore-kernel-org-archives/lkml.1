Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYDYMZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYDYMZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYDYMZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:25:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:1728 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYDYMZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ir88zi2Zbg1Se2+pIMfPg1fYWB6yaI+zC4CSxE/isQyW8GWF5yZo+6gKkFbELpjweQOFwQDOf4Wke17XPHCroWX8Qe7VEX/QT6qtwyuQrNCEFV8Akw7bx4+PS1smTnfLQyzlzdafTUAABtmVHXsXwRTBsmdVqN/b/fHmGBALv+0=
Message-ID: <efa8e58e0804250525tfaefc89r28f788356a31e90e@mail.gmail.com>
Date: Fri, 25 Apr 2008 14:25:22 +0200
From: "=?UTF-8?Q?Rune_V._Sj=C3=B8en?=" <rvsjoen@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix compilation warning "discards qualifiers from pointer target type"
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation warning "discards qualifiers from pointer target type"
in include/asm-x86/io_32.h

Signed-off-by: Rune V. Sjoen <rvsjoen@gmail.com>
---

--- clean/include/asm-x86/io_32.h       2008-04-17 04:49:44.000000000 +0200
+++ linux/include/asm-x86/io_32.h       2008-04-25 13:52:19.000000000 +0200
@@ -211,7 +211,7 @@ memset_io(volatile void __iomem *addr, u
 }

 static inline void
-memcpy_fromio(void *dst, const volatile void __iomem *src, int count)
+memcpy_fromio(void *dst, const void __iomem *src, int count)
 {
        __memcpy(dst, (const void __force *)src, count);
 }
