Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbZLBMvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbZLBMvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZLBMvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:51:25 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:52722 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbZLBMvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:51:24 -0500
From: Ian Molton <ian.molton@collabora.co.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, herbert@gondor.apana.org.au,
       Ian Molton <ian.molton@collabora.co.uk>
Subject: [PATCH] hw_random: prevent too-small buffer sizes
Date: Wed,  2 Dec 2009 12:50:38 +0000
Message-Id: <1259758238-3507-1-git-send-email-ian.molton@collabora.co.uk>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This patch prevents the hw_random core using too small of a buffer
on machines with small cacheline sizes.

Signed-off-by: Ian Molton <ian.molton@collabora.co.uk>
---
 drivers/char/hw_random/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 5c2d13c..8b7d56a 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -53,7 +53,8 @@ static struct hwrng *current_rng;
 static LIST_HEAD(rng_list);
 static DEFINE_MUTEX(rng_mutex);
 static int data_avail;
-static u8 rng_buffer[SMP_CACHE_BYTES] __cacheline_aligned;
+static u8 rng_buffer[SMP_CACHE_BYTES < 32 ? 32 : SMP_CACHE_BYTES]
+	__cacheline_aligned;
 
 static inline int hwrng_init(struct hwrng *rng)
 {
-- 
1.6.5

