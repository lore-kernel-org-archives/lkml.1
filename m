Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZH0OGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZH0OGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 10:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZH0OGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 10:06:20 -0400
Received: from zola.planet-work.net ([79.99.160.15]:40593 "EHLO
	zola.planet-work.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZH0OGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 10:06:17 -0400
X-Greylist: delayed 2129 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 10:06:17 EDT
Date: Thu, 27 Aug 2009 15:26:58 +0200
From: Julien TINNES <julien@cr0.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, davem@davemloft.net, security@kernel.org,
       taviso@sdf.lonestar.org
Subject: [PATCH] ipv4: make ip_append_data() handle NULL routing table
Message-ID: <20090827132658.GA17099@cr0.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check in ip_append_data() for NULL *rtp to prevent future bugs in callers from being exploitable.

Signed-off-by: Julien Tinnes <julien@cr0.org>
Signed-off-by: Tavis Ormandy <taviso@sdf.lonestar.org>
Acked-by: David S. Miller <davem@davemloft.net>

---

diff -r b3cbf0ceeb34 net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c	Mon Aug 24 14:48:29 2009 +0200
+++ b/net/ipv4/ip_output.c	Thu Aug 27 15:20:36 2009 +0200
@@ -814,6 +814,8 @@
 			inet->cork.addr = ipc->addr;
 		}
 		rt = *rtp;
+		if (unlikely(!rt))
+			return -EFAULT;
 		/*
 		 * We steal reference to this route, caller should not release it
 		 */
