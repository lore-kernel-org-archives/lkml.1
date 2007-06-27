Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbXF0Fxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbXF0Fxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXF0Fxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:53:41 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:48498 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXF0Fxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:53:40 -0400
Message-ID: <4681FB53.1020609@linux.vnet.ibm.com>
Date: Wed, 27 Jun 2007 11:23:23 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, sam@ravnborg.org
CC: akpm@linux-foundation.org
Subject: [PATCH] Fix the warning when running make tags
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


make tags was giving the below warning.

ctags: Warning: arch/x86_64/kernel/head.S:124: null expansion of name
pattern "\1"

Fix the same by making sure we taken only ENTRY pattern found at the
begining of the line.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 8a3c271..9c2670e 100644
--- a/Makefile
+++ b/Makefile
@@ -1316,7 +1316,7 @@ define xtags
 		-I __initdata,__exitdata,__acquires,__releases \
 		-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL \
 		--extra=+f --c-kinds=+px \
-		--regex-asm='/ENTRY\(([^)]*)\).*/\1/'; \
+		--regex-asm='/^ENTRY\(([^)]*)\).*/\1/'; \
 	    $(all-kconfigs) | xargs $1 -a \
 		--langdef=kconfig \
 		--language-force=kconfig \
-- 
1.5.2.2.571.ge1341-dirty

