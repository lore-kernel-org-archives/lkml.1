Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbYH0N5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbYH0N5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755677AbYH0Ntx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:49:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbYH0Ntu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:49:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 09/59] CRED: Wrap task credential accesses in the DRM driver
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net
Date: Wed, 27 Aug 2008 14:46:28 +0100
Message-ID: <20080827134628.19980.80653.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
---

 drivers/gpu/drm/drm_fops.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index 851a53f..dcf8b4d 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -246,7 +246,7 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 	memset(priv, 0, sizeof(*priv));
 	filp->private_data = priv;
 	priv->filp = filp;
-	priv->uid = current->euid;
+	priv->uid = current_euid();
 	priv->pid = task_pid_nr(current);
 	priv->minor = idr_find(&drm_minors_idr, minor_id);
 	priv->ioctl_count = 0;

