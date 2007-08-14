Return-Path: <linux-kernel-owner+w=401wt.eu-S1756016AbXHNJGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbXHNJGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXHNJGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:06:30 -0400
Received: from iona.labri.fr ([147.210.8.143]:56064 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbXHNJG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:06:28 -0400
Date: Tue, 14 Aug 2007 11:00:23 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: akpm@google.com, kernel@vger.kernel.org, dtor@mail.ru,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Keyboard CapsShift Lock
Message-ID: <20070814090023.GB3344@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	akpm@google.com, kernel@vger.kernel.org, dtor@mail.ru,
	linux-input@atrey.karlin.mff.cuni.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There exists a CapsShift lock called KG_CAPSSHIFT, but no associated
lock/slock, here is a patch.

Samuel

Add CapsShift lock and slock.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/include/linux/keyboard.h b/include/linux/keyboard.h
index d97066f..61f12d4 100644
--- a/include/linux/keyboard.h
+++ b/include/linux/keyboard.h
@@ -426,6 +426,7 @@ extern int unregister_keyboard_notifier(struct notifier_block *nb);
 #define K_SHIFTRLOCK	K(KT_LOCK,KG_SHIFTR)
 #define K_CTRLLLOCK	K(KT_LOCK,KG_CTRLL)
 #define K_CTRLRLOCK	K(KT_LOCK,KG_CTRLR)
+#define K_CAPSSHIFTLOCK	K(KT_LOCK,KG_CAPSSHIFT)
 
 #define K_SHIFT_SLOCK	K(KT_SLOCK,KG_SHIFT)
 #define K_CTRL_SLOCK	K(KT_SLOCK,KG_CTRL)
@@ -435,8 +436,9 @@ extern int unregister_keyboard_notifier(struct notifier_block *nb);
 #define K_SHIFTR_SLOCK	K(KT_SLOCK,KG_SHIFTR)
 #define K_CTRLL_SLOCK	K(KT_SLOCK,KG_CTRLL)
 #define K_CTRLR_SLOCK	K(KT_SLOCK,KG_CTRLR)
+#define K_CAPSSHIFT_SLOCK	K(KT_SLOCK,KG_CAPSSHIFT)
 
-#define NR_LOCK		8
+#define NR_LOCK		9
 
 #define K_BRL_BLANK     K(KT_BRL, 0)
 #define K_BRL_DOT1      K(KT_BRL, 1)
