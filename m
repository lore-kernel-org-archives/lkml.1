Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZFEIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZFEIIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755285AbZFEIFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37479 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017AbZFEIFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 08/62] Blackfin: fix bug found by traps test case 21
Date: Fri,  5 Jun 2009 04:04:17 -0400
Message-Id: <1244189111-19639-9-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The traps test case 21 "exception 0x3f: l1_instruction_access" would make
the kernel panic on BF533's because we end up calling show_stack()
infinitely.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/mm/isram-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mm/isram-driver.c b/arch/blackfin/mm/isram-driver.c
index 22913e7..c080e70 100644
--- a/arch/blackfin/mm/isram-driver.c
+++ b/arch/blackfin/mm/isram-driver.c
@@ -125,7 +125,7 @@ static bool isram_check_addr(const void *addr, size_t n)
 {
 	if ((addr >= (void *)L1_CODE_START) &&
 	    (addr < (void *)(L1_CODE_START + L1_CODE_LENGTH))) {
-		if ((addr + n) >= (void *)(L1_CODE_START + L1_CODE_LENGTH)) {
+		if ((addr + n) > (void *)(L1_CODE_START + L1_CODE_LENGTH)) {
 			show_stack(NULL, NULL);
 			printk(KERN_ERR "isram_memcpy: copy involving %p length "
 					"(%zu) too long\n", addr, n);
-- 
1.6.3.1

