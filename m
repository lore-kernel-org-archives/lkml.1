Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbXJXQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbXJXQ27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbXJXQXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:11 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33338 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754929AbXJXQXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:09 -0400
Date: Wed, 24 Oct 2007 18:23:39 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/cgroup.c: make 2 functions static
Message-ID: <20071024162339.GT30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_is_releasable() and notify_on_release() should be static,
not global inline.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

626d10ec224de07fc7906b0aa82e035e153709ce 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5987dcc..fec1726 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -143,7 +143,7 @@ enum {
 	ROOT_NOPREFIX, /* mounted subsystems have no named prefix */
 };
 
-inline int cgroup_is_releasable(const struct cgroup *cgrp)
+static int cgroup_is_releasable(const struct cgroup *cgrp)
 {
 	const int bits =
 		(1 << CGRP_RELEASABLE) |
@@ -151,7 +151,7 @@ inline int cgroup_is_releasable(const struct cgroup *cgrp)
 	return (cgrp->flags & bits) == bits;
 }
 
-inline int notify_on_release(const struct cgroup *cgrp)
+static int notify_on_release(const struct cgroup *cgrp)
 {
 	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 }

