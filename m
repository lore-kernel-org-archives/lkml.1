Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZCWNzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZCWNzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 09:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZCWNy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 09:54:59 -0400
Received: from mx1.emlix.com ([193.175.82.87]:46635 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZCWNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:54:59 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org, linux-xtensa@linux-xtensa.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch] xtensa: make startup code discardable
Date: Mon, 23 Mar 2009 14:55:09 +0100
Message-Id: <1237816509-28978-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move it from .text to .init.text to get rid of it after boot and
prevent illegal section references.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 arch/xtensa/kernel/head.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/head.S b/arch/xtensa/kernel/head.S
index d092c22..0817f9d 100644
--- a/arch/xtensa/kernel/head.S
+++ b/arch/xtensa/kernel/head.S
@@ -53,7 +53,7 @@ _start:	_j	2f
 2:	l32r	a0, 1b
 	jx	a0
 
-	.text
+	.section .init.text, "ax"
 	.align 4
 _startup:
 
-- 
1.6.2.107.ge47ee

