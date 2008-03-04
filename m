Return-Path: <linux-kernel-owner+w=401wt.eu-S1763330AbYCDLiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763330AbYCDLiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYCDLiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:38:14 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:34613 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755507AbYCDLiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:38:13 -0500
Date: Tue, 4 Mar 2008 17:08:06 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org, apw@shadowen.org
Subject: [PATCH] 2.6.25-rc3-git5 Build fails on s390x
Message-ID: <20080304113806.GA27293@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 2.6.25-rc3-git5 kernel build fails on s390x with

drivers/s390/char/defkeymap.c:155: error: missing terminating ' character
drivers/s390/char/defkeymap.c:156: error: syntax error before ';' token
make[2]: *** [drivers/s390/char/defkeymap.o] Error 1
make[1]: *** [drivers/s390/char] Error 2
make: *** [drivers/s390] Error 2

I have tested the patch for build failure only.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
diff --git a/drivers/s390/char/defkeymap.c b/drivers/s390/char/defkeymap.c
index 9692d6a..07c7f31 100644
--- a/drivers/s390/char/defkeymap.c
+++ b/drivers/s390/char/defkeymap.c
@@ -152,7 +152,7 @@ char *func_table[MAX_NR_FUNC] = {
 
 struct kbdiacruc accent_table[MAX_DIACR] = {
 	{'^', 'c', 0003},	{'^', 'd', 0004},
-	{'^', 'z', 0032},	{'^', 0012', 0000},
+	{'^', 'z', 0032},	{'^', 0012, 0000},
 };
 
 unsigned int accent_table_size = 4;
-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
