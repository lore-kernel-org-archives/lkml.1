Return-Path: <linux-kernel-owner+w=401wt.eu-S935005AbXGZQi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935005AbXGZQi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934328AbXGZQew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:34:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35558 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934307AbXGZQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:50 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] use CLOCKSOURCE_MASK() instead of too large constant
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com
Message-Id: <E1IE6Ib-0005Jt-MO@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:34:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/ia64/kernel/time.c |    2 +-
 drivers/char/hpet.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 1169d46..6c0e9e2 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -52,7 +52,7 @@ static struct clocksource clocksource_itc = {
         .name           = "itc",
         .rating         = 350,
         .read           = itc_get_cycles,
-        .mask           = 0xffffffffffffffff,
+        .mask           = CLOCKSOURCE_MASK(64),
         .mult           = 0, /*to be caluclated*/
         .shift          = 16,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 9a2694e..77bf4aa 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -73,7 +73,7 @@ static struct clocksource clocksource_hpet = {
         .name           = "hpet",
         .rating         = 250,
         .read           = read_hpet,
-        .mask           = 0xffffffffffffffff,
+        .mask           = CLOCKSOURCE_MASK(64),
         .mult           = 0, /*to be caluclated*/
         .shift          = 10,
         .flags          = CLOCK_SOURCE_IS_CONTINUOUS,
-- 
1.5.3.GIT


