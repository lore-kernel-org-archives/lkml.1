Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbYJTRYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbYJTRYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYJTRXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:23:45 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60932 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758404AbYJTRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:23:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rRNe0ooi59cx8O5DSLXrDKxfiwNHYggdqobI5FjisTC2gFkRy0KxsJIB1Cramaoz2V
         k56CnkRDufdqzM6ZpfD2XI5lxBAoh80IpLFHI1+3jVo2I88pjsPWm0DcwRumiYQkPVG9
         sh+5b3WpMpepwqWhS6EeMMInyX8KK126TRgBw=
Subject: [PATCH] byteorder: remove direct includes of
 linux/byteorder/swab[b].h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 10:23:38 -0700
Message-Id: <1224523418.31861.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A consolidated implementation will provide this generically through
asm/byteorder, remove direct includes to avoid breakage when the
changeover to the new implementation occurs.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Andrew, this hunk seems to have been lost when you sent it to Linus, it's possible
you applied this on top of the -next tree where this file has moved, but the tests
tree hasn't been pulled yet.

The rest of the patch went into mainline as 1d8cca44b6a244b7e378546d719041819049a0f9

I believe it was acked-by Paul, but CC'd to be sure.

 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 90b5b12..85cb905 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -42,10 +42,10 @@
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
-#include <linux/byteorder/swabb.h>
 #include <linux/stat.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <asm/byteorder.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and "
-- 
1.6.0.2



