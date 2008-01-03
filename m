Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbYACLIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbYACLIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 06:08:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYACLIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 06:08:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:33864 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbYACLIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 06:08:46 -0500
Date: Thu, 3 Jan 2008 12:08:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: don't #error on higher HZ values
Message-ID: <20080103110850.GA2420@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For some crazy reason (trying to work around hw problem in i810) I
wanted to use HZ around 4000.


Signed-off-by: Pavel Machek <pavel@suse.cz>
									Pavel

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 8b08002..7ba9e47 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -29,6 +29,12 @@ #elif HZ >= 384 && HZ < 768
 # define SHIFT_HZ	9
 #elif HZ >= 768 && HZ < 1536
 # define SHIFT_HZ	10
+#elif HZ >= 1536 && HZ < 3072
+# define SHIFT_HZ	11
+#elif HZ >= 3072 && HZ < 6144
+# define SHIFT_HZ	12
+#elif HZ >= 6144 && HZ < 12288
+# define SHIFT_HZ	13
 #else
 # error You lose.
 #endif
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
