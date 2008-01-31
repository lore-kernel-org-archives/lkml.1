Return-Path: <linux-kernel-owner+w=401wt.eu-S1764943AbYAaPJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764943AbYAaPJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYAaPJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:09:27 -0500
Received: from qb-out-0506.google.com ([72.14.204.227]:18868 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481AbYAaPJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:09:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=fuieC+rXVwQicfZS5Sb1RbbUjj+VoDzVgQpFyrxgT5/+rGplE/O/W6MuETeYEIqnHVrcVoe58lG/rXooZtEZ4T7Cw5INEqkqnAV5uj60oc3baLkC8Rp+wB5F1u7YIWfAsCSgWzjpeX3PQB7tvJI9fuTC/VGkIwT21SY86utiGt8=
Date: Thu, 31 Jan 2008 23:06:34 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] arch/um/include/init.h: Fix missing macro definitions
Message-ID: <20080131150634.GC2471@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixed the following build error in current -git tree.

arch/um/kernel/config.c:10: error: expected declaration specifiers or '...' before '.' token
...


Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/um/include/init.h b/arch/um/include/init.h
index cebc6ca..70982e1 100644
--- a/arch/um/include/init.h
+++ b/arch/um/include/init.h
@@ -40,6 +40,18 @@
 typedef int (*initcall_t)(void);
 typedef void (*exitcall_t)(void);
 
+#ifndef __section
+# define __section(S) __attribute__ ((__section__(#S)))
+#endif
+
+#ifndef __used
+#if __GNUC__ == 3 && __GNUC_MINOR__ == 2
+# define __used                 __attribute__((__unused__))
+#else
+# define __used                 __attribute__((__used__))
+#endif
+#endif
+
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
 #define __init		__section(.init.text)
