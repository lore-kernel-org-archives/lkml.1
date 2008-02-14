Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbYBNH0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbYBNH0o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932311AbYBNH03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:26:29 -0500
Received: from pip12.gyao.ne.jp ([61.122.117.250]:42641 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764760AbYBNH02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:26:28 -0500
Date: Thu, 14 Feb 2008 16:25:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] markers: Fix build for MODULES=n.
Message-ID: <20080214072517.GG12436@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      kernel/marker.o
kernel/marker.c: In function 'marker_update_probes':
kernel/marker.c:627: error: too few arguments to function 'module_update_markers'
make[1]: *** [kernel/marker.o] Error 1
make: *** [kernel] Error 2

module_update_markers() doesn't take any arguments, update the MODULES=n
version of it to reflect that.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/linux/module.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 330bec0..819c4e8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -567,8 +567,7 @@ static inline void print_modules(void)
 {
 }
 
-static inline void module_update_markers(struct module *probe_module,
-		int *refcount)
+static inline void module_update_markers(void)
 {
 }
 
