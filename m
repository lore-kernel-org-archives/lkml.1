Return-Path: <linux-kernel-owner+w=401wt.eu-S1031184AbXDSLQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031184AbXDSLQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030973AbXDSLQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:16:41 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:41370 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030970AbXDSLQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=YxEkRAc6fG1kcxzIF8bjI8uaW2qattlavrjYCx36LXVPhQU26oo4L5YYPRoIWLuiW4E6CR+Xy6nmKmXKD6udkm0yUmsh+xc9RlyhurrYjjDiN0FwIkPwHy1dWhKG6a1Ddq/erRcJvqevLaZSTGXlxclFLH5vtmGtI8AU+xrKoFY=
Date: Thu, 19 Apr 2007 16:49:02 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: Kernel Janitors <kernel-janitors@lists.osdl.org>,
       INPUT <linux-input@atrey.karlin.mff.cuni.cz>
Cc: Andrw Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
Subject: [KJ][PATCH]SPIN_LOCK_UNLOCKED cleanup in drivers/char/keyboard
Message-ID: <20070419111902.GB11493@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCKED cleanup,use __SPIN_LOCK_UNLOCKED instead 

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 keyboard.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index cb8d691..df9bfc1 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -110,7 +110,7 @@ struct kbd_struct kbd_table[MAX_NR_CONSOLES];
 static struct kbd_struct *kbd = kbd_table;
 
 struct vt_spawn_console vt_spawn_con = {
-	.lock = SPIN_LOCK_UNLOCKED,
+	.lock = __SPIN_LOCK_UNLOCKED(vt_spawn_con.lock),
 	.pid  = NULL,
 	.sig  = 0,
 };
-- 
Milind Arun Choudhary
