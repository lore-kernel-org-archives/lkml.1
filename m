Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbYJPLHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbYJPLHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYJPLH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:07:28 -0400
Received: from bender.cm4all.net ([87.106.27.49]:44829 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYJPLH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:07:27 -0400
X-Greylist: delayed 1265 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2008 07:07:27 EDT
From: Max Kellermann <mk@cm4all.com>
Subject: [PATCH] linux/ratelimit.h: fixed "missing initializer" warning
To: linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2008 12:45:11 +0200
Message-ID: <20081016104511.28037.13905.stgit@rabbit.intern.cm-ag>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiled with -Wmissing-field-initializers (-Wextra), gcc
complains that there are uninitialized fields in the struct:

 include/linux/ratelimit.h: In function 'ratelimit':
 include/linux/ratelimit.h:23: warning: missing initializer
 include/linux/ratelimit.h:23: warning: (near initialization for 'rs.printed')

Work around this by using C99 initializers.  This seems more safe
anyway, just in case someone changes the ratelimit_state struct.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---

 include/linux/ratelimit.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
index 18a5b9b..cb29b0c 100644
--- a/include/linux/ratelimit.h
+++ b/include/linux/ratelimit.h
@@ -13,8 +13,11 @@ struct ratelimit_state {
 	unsigned long begin;
 };
 
-#define DEFINE_RATELIMIT_STATE(name, interval, burst)		\
-		struct ratelimit_state name = {interval, burst,}
+#define DEFINE_RATELIMIT_STATE(name, _interval, _burst) \
+		struct ratelimit_state name = { \
+			.interval = _interval, \
+			.burst = _burst, \
+		}
 
 extern int __ratelimit(struct ratelimit_state *rs);
 

