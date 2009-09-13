Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbZIMCze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbZIMCze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 22:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZIMCzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 22:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921AbZIMCzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 22:55:17 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] SELinux: flush the avc before disabling SELinux
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: sds@tycho.nsa.gov, jmorris@namei.org, mingo@elte.hu, dhowells@redhat.com
Date: Sat, 12 Sep 2009 22:54:23 -0400
Message-ID: <20090913025423.6583.62118.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before SELinux is disabled at boot it can create AVC entries.  This patch
will flush those entries before disabling SELinux.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/selinux/avc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index f601246..1ed0f07 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -868,6 +868,8 @@ u32 avc_policy_seqno(void)
 
 void avc_disable(void)
 {
+	avc_flush();
+	synchronize_rcu();
 	if (avc_node_cachep)
 		kmem_cache_destroy(avc_node_cachep);
 }

