Return-Path: <linux-kernel-owner+w=401wt.eu-S1758491AbXGJQF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491AbXGJQF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXGJQFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:05:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27926 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXGJQFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type;
        b=WDdiXjDx/o+ewMOm7OmghZ6Qet1VomS7ctnksC40nVpd2ror4GD3wDRrAEDrNKtaPlb571CK9WpdhdwyKk0xZCuWP+Uthlq8lrqU/veP9iPJSWX9fVpQnuA4VNTrLzMkVE1kPv4g5p9U8j6T2Q6JlOYNutJCp8MEAyT7LNFwDfs=
Message-ID: <4693AE32.7030403@gmail.com>
Date: Tue, 10 Jul 2007 18:05:06 +0200
From: Adel Gadllah <adel.gadllah@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix sparse problems with ARRAY_SIZE
Content-Type: multipart/mixed;
 boundary="------------070208070406060503000407"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070208070406060503000407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ARRAY_SIZE seems to create sparse warnings when used on global 
variables. The attached patch fixes this by using a ARRAY_SIZE macro 
that does not use __must_be_array(arr) for sparse.
See: http://marc.info/?t=118103449100007&r=1&w=2

P.S: please CC me

--------------070208070406060503000407
Content-Type: text/x-patch;
 name="array_size_sparse_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="array_size_sparse_fix.patch"

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff -upNr linux-2.6.orig/include/linux/kernel.h linux-2.6/include/linux/kernel.h
--- linux-2.6.orig/include/linux/kernel.h	2007-07-10 17:53:39.000000000 +0200
+++ linux-2.6/include/linux/kernel.h	2007-07-10 18:01:30.000000000 +0200
@@ -35,7 +35,11 @@ extern const char linux_proc_banner[];
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
 
+#ifdef __CHECKER_
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((x)[0]))
+#else
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
+#endif
 
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
 #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))

--------------070208070406060503000407--
