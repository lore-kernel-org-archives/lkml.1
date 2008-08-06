Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbYHFK6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbYHFK6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbYHFK6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:58:47 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:5997 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbYHFK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Cb91LAE3rUukeQrSpwepIQFqB8w1DlnJJ0uK92er3Qvib0XjIkEShUzy7ET9AVeiRr
         k47wZOznlvEepLH9lRbREVsPrtkUj602Wgw7hzCSEr5mrl4iOPheGTbSOFJ5zgBwOXyU
         X+EQUnI2EqYsYGdshDUHxHam3IrnBVBKYgRfk=
Date: Wed, 6 Aug 2008 12:58:36 +0200
To: Bryan Wu <cooloney@kernel.org>
Cc: Julia Lawall <julia@diku.dk>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags
Message-ID: <20080806105836.GA2903@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Use a wider diff context such as -U10 after the patch has been applied to
see the actual uses of the variables which we change.)

>From 3ef36948a88a968eec1b09859aa251dc6727df4e Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Wed, 6 Aug 2008 12:00:23 +0200
Subject: [PATCH] blackfin/sram: use 'unsigned long' for irqflags

Using just 'unsigned' will make flags an unsigned int. While this is
arguably not an error on blackfin where sizeof(int) == sizeof(long),
the patch is still justified on the grounds of principle.

The patch was generated using the Coccinelle semantic patch framework.

Cc: Julia Lawall <julia@diku.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/blackfin/mm/blackfin_sram.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index 5af3c31..9bc6aed 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -379,7 +379,7 @@ EXPORT_SYMBOL(sram_free);
 
 void *l1_data_A_sram_alloc(size_t size)
 {
-	unsigned flags;
+	unsigned long flags;
 	void *addr = NULL;
 
 	/* add mutex operation */
@@ -402,7 +402,7 @@ EXPORT_SYMBOL(l1_data_A_sram_alloc);
 
 int l1_data_A_sram_free(const void *addr)
 {
-	unsigned flags;
+	unsigned long flags;
 	int ret;
 
 	/* add mutex operation */
@@ -425,7 +425,7 @@ EXPORT_SYMBOL(l1_data_A_sram_free);
 void *l1_data_B_sram_alloc(size_t size)
 {
 #if L1_DATA_B_LENGTH != 0
-	unsigned flags;
+	unsigned long flags;
 	void *addr;
 
 	/* add mutex operation */
@@ -450,7 +450,7 @@ EXPORT_SYMBOL(l1_data_B_sram_alloc);
 int l1_data_B_sram_free(const void *addr)
 {
 #if L1_DATA_B_LENGTH != 0
-	unsigned flags;
+	unsigned long flags;
 	int ret;
 
 	/* add mutex operation */
@@ -504,7 +504,7 @@ EXPORT_SYMBOL(l1_data_sram_free);
 void *l1_inst_sram_alloc(size_t size)
 {
 #if L1_CODE_LENGTH != 0
-	unsigned flags;
+	unsigned long flags;
 	void *addr;
 
 	/* add mutex operation */
@@ -529,7 +529,7 @@ EXPORT_SYMBOL(l1_inst_sram_alloc);
 int l1_inst_sram_free(const void *addr)
 {
 #if L1_CODE_LENGTH != 0
-	unsigned flags;
+	unsigned long flags;
 	int ret;
 
 	/* add mutex operation */
@@ -551,7 +551,7 @@ EXPORT_SYMBOL(l1_inst_sram_free);
 /* L1 Scratchpad memory allocate function */
 void *l1sram_alloc(size_t size)
 {
-	unsigned flags;
+	unsigned long flags;
 	void *addr;
 
 	/* add mutex operation */
@@ -569,7 +569,7 @@ void *l1sram_alloc(size_t size)
 /* L1 Scratchpad memory allocate function */
 void *l1sram_alloc_max(size_t *psize)
 {
-	unsigned flags;
+	unsigned long flags;
 	void *addr;
 
 	/* add mutex operation */
@@ -587,7 +587,7 @@ void *l1sram_alloc_max(size_t *psize)
 /* L1 Scratchpad memory free function */
 int l1sram_free(const void *addr)
 {
-	unsigned flags;
+	unsigned long flags;
 	int ret;
 
 	/* add mutex operation */
@@ -605,7 +605,7 @@ int l1sram_free(const void *addr)
 void *l2_sram_alloc(size_t size)
 {
 #ifdef L2_LENGTH
-	unsigned flags;
+	unsigned long flags;
 	void *addr;
 
 	/* add mutex operation */
@@ -641,7 +641,7 @@ EXPORT_SYMBOL(l2_sram_zalloc);
 int l2_sram_free(const void *addr)
 {
 #ifdef L2_LENGTH
-	unsigned flags;
+	unsigned long flags;
 	int ret;
 
 	/* add mutex operation */
-- 
1.5.5.1

