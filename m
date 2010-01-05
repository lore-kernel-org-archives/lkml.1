Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926Ab0AEApk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0AEApk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754379Ab0AEAfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:36 -0500
Received: from kroah.org ([198.145.64.141]:34386 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab0AEAfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 51/97] ath9k_hw: Fix possible OOB array indexing in gen_timer_index[] on 64-bit
Date: Mon,  4 Jan 2010 16:33:04 -0800
Message-Id: <1262651630-7354-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit c90017dd43f0cdb42134b9229761e8be02bcd524 upstream.

debruijn32 (0x077CB531) is used to index gen_timer_index[]
which is an array of 32 u32. Having debruijn32 as unsigned
long on a 64-bit platform  will result in indexing more than 32
in gen_timer_index[] and there by causing a crash. Make it
unsigned to fix this issue.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/hw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 57f1463..ff4383b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -408,7 +408,7 @@ struct ath9k_hw_version {
  * Using de Bruijin sequence to to look up 1's index in a 32 bit number
  * debruijn32 = 0000 0111 0111 1100 1011 0101 0011 0001
  */
-#define debruijn32 0x077CB531UL
+#define debruijn32 0x077CB531U
 
 struct ath_gen_timer_configuration {
 	u32 next_addr;
-- 
1.6.6

