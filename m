Return-Path: <linux-kernel-owner+w=401wt.eu-S934252AbYCEMCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbYCEMCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbYCEL5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:57:39 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:16554 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762691AbYCEL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:57:20 -0500
Message-Id: <20080305115714.669054011@de.ibm.com>
References: <20080305115432.691030908@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 05 Mar 2008 12:54:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 08/10] Fix IPL from NSS.
Content-Disposition: inline; filename=008-maxorder.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

IPL from NSS didn't work because the memory detection routine omits any
memory sections with a size lower than what MAX_ORDER defines.
This causes the detection routine to skip the first memory segment which
has a size of 1MB. Which later on will let the kernel think that there
is no memory available at all.
Since in addition the z/VM memory increment size is 1MB force MAX_ORDER
to be 9, so we can support 1MB segments.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

Index: quilt-2.6/arch/s390/Kconfig
===================================================================
--- quilt-2.6.orig/arch/s390/Kconfig
+++ quilt-2.6/arch/s390/Kconfig
@@ -351,6 +351,10 @@ endchoice
 
 source "fs/Kconfig.binfmt"
 
+config FORCE_MAX_ZONEORDER
+	int
+	default "9"
+
 config PROCESS_DEBUG
 	bool "Show crashed user process info"
 	help

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

