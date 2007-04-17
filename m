Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXDQUCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXDQUCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161115AbXDQUCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:02:07 -0400
Received: from av1.karneval.cz ([81.27.192.123]:19746 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161209AbXDQUCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:02:05 -0400
Message-id: <210731960111436322@karneval.cz>
Subject: [RFC 1/2] Input: ff, add FF_RAW effect
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: johann deneux <johann.deneux@gmail.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>
Cc: <stenyak@gmail.com>
Cc: <linux-input@atrey.karlin.mff.cuni.cz>
Date: Tue, 17 Apr 2007 22:01:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So fellows, what about these ones?

--

ff, add FF_RAW effect

Add new FF_RAW effect for devices such Phantom. The new model has up to 6DOF
torque force feedback independent on any 3d-or-so value.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 759e7f172031959f49e5d3a7282379e7d73621b3
tree 906d51925ff7f95ebae8148ef2f1b2f252ef3f4e
parent bd99756ce7fb8f3e9105b076a71046b0d8ad1f8f
author Jiri Slaby <jirislaby@gmail.com> Tue, 17 Apr 2007 21:50:21 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 17 Apr 2007 21:50:21 +0200

 drivers/input/ff-memless.c |    4 ++++
 include/linux/input.h      |    4 +++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index d226d93..3bbace9 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -275,6 +275,10 @@ static void ml_combine_effects(struct ff_effect *effect,
 			min(i + effect->u.rumble.weak_magnitude, 0xffffU);
 		break;
 
+	case FF_RAW:
+		memcpy(effect->u.ff_raw, new->u.ff_raw, sizeof(new->u.ff_raw));
+		break;
+
 	default:
 		printk(KERN_ERR "ff-memless: invalid type in ml_combine_effects()\n");
 		break;
diff --git a/include/linux/input.h b/include/linux/input.h
index 2a23768..cc4ae1f 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -859,6 +859,7 @@ struct ff_effect {
 		struct ff_periodic_effect periodic;
 		struct ff_condition_effect condition[2]; /* One for each axis */
 		struct ff_rumble_effect rumble;
+		__u32 ff_raw[6];
 	} u;
 };
 
@@ -874,9 +875,10 @@ struct ff_effect {
 #define FF_DAMPER	0x55
 #define FF_INERTIA	0x56
 #define FF_RAMP		0x57
+#define FF_RAW		0x58
 
 #define FF_EFFECT_MIN	FF_RUMBLE
-#define FF_EFFECT_MAX	FF_RAMP
+#define FF_EFFECT_MAX	FF_RAW
 
 /*
  * Force feedback periodic effect types
