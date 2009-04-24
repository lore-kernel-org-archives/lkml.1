Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbZDXPK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbZDXPK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 11:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752876AbZDXPKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 11:10:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:30458 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZDXPKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 11:10:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OuGPwQP11PRBNHO7I4hGxsC0l4awxB897pus3BGBclgdqyAS6GfdMSPP/b3dsZXR/S
         nX3zgZMjv5rstwcjAyNykFSgPuL3ZLCRHU90fnAQGH7GJIYJKwkP4ikPauY0dxzKEmn5
         4FXszq/+w5yp0QQ+k1A5U7gKJrL2vPBG0L4FI=
From: tom.leiming@gmail.com
To: mingo@elte.hu, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] Documentation:lockdep-design: fix note of state bits
Date: Fri, 24 Apr 2009 23:10:06 +0800
Message-Id: <1240585806-5744-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

>From source code of get_usage_char(), the previous note is not correct,
so fix it.

static char get_usage_char(struct lock_class *class, enum lock_usage_bit bit)
{
	char c = '.';

	if (class->usage_mask & lock_flag(bit + 2))/*LOCK_ENABLED_##STATE*/
		c = '+';
	if (class->usage_mask & lock_flag(bit)) {/*LOCK_USED_IN_##STATE*/
		c = '-';
		if (class->usage_mask & lock_flag(bit + 2))
			c = '?';
	}

	return c;
}
note:
1),The 'bit' parameter always is passed as  LOCK_USED_IN_##STATE
or LOCK_USED_IN_##STATE_READ , from get_usage_chars().

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 Documentation/lockdep-design.txt |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/lockdep-design.txt b/Documentation/lockdep-design.txt
index 938ea22..e20d913 100644
--- a/Documentation/lockdep-design.txt
+++ b/Documentation/lockdep-design.txt
@@ -54,9 +54,9 @@ locking error messages, inside curlies. A contrived example:
 The bit position indicates STATE, STATE-read, for each of the states listed
 above, and the character displayed in each indicates:
 
-   '.'  acquired while irqs disabled
-   '+'  acquired in irq context
-   '-'  acquired with irqs enabled
+   '.'  acquired while irqs disabled and not in irq context
+   '-'  acquired in irq context
+   '+'  acquired with irqs enabled
    '?'  acquired in irq context with irqs enabled.
 
 Unused mutexes cannot be part of the cause of an error.
-- 
1.6.0.GIT

