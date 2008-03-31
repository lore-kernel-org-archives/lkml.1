Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYCaWGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYCaWGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbYCaWGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:06:36 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:55233 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998AbYCaWGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:06:34 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] [MIPS] make mdesc and prom_getmdesc() static
Date: Tue,  1 Apr 2008 02:03:22 +0400
Message-Id: <1207001005-2633-4-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither the mdesc[] array nor the prom_getmdesc() function need to
be global. This patch makes them static.

Successfully build-tested using default configs for Malta, Atlas
and SEAD boards.

Runtime test successfully performed by booting the Malta 4Kc board
up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/generic/memory.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mips-boards/generic/memory.c b/arch/mips/mips-boards/generic/memory.c
index dc272c1..5e443bb 100644
--- a/arch/mips/mips-boards/generic/memory.c
+++ b/arch/mips/mips-boards/generic/memory.c
@@ -37,7 +37,7 @@ enum yamon_memtypes {
 	yamon_prom,
 	yamon_free,
 };
-struct prom_pmemblock mdesc[PROM_MAX_PMEMBLOCKS];
+static struct prom_pmemblock mdesc[PROM_MAX_PMEMBLOCKS];
 
 #ifdef DEBUG
 static char *mtypes[3] = {
@@ -50,7 +50,7 @@ static char *mtypes[3] = {
 /* determined physical memory size, not overridden by command line args  */
 unsigned long physical_memsize = 0L;
 
-struct prom_pmemblock * __init prom_getmdesc(void)
+static struct prom_pmemblock * __init prom_getmdesc(void)
 {
 	char *memsize_str;
 	unsigned int memsize;
-- 
1.5.3

