Return-Path: <linux-kernel-owner+w=401wt.eu-S1761742AbZLPOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761742AbZLPOgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760635AbZLPOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:36:20 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59843 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759202AbZLPOgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:36:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c0SDvVkSWMjqyqq2Mkx9LeYWCkcvzI3aUdH8efPUz1bQpPzyFOSuJP6hc2+5pSlM+0
         w6jHjztvMTdegZYsXigctmGArdHl5d1erxGgVuz13mTnOIAQzDUvmV6yxyXoqlYH5ogk
         a5db5LnEowsNpmCP6Md/2dvCkxeaCOIjT0wa4=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH 1/5] powerpc/iseries: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 22:35:57 +0800
Message-Id: <1260974161-6934-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org
---
 arch/powerpc/platforms/iseries/viopath.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/iseries/viopath.c b/arch/powerpc/platforms/iseries/viopath.c
index 49ff4dc..5aea94f 100644
--- a/arch/powerpc/platforms/iseries/viopath.c
+++ b/arch/powerpc/platforms/iseries/viopath.c
@@ -116,7 +116,7 @@ static int proc_viopath_show(struct seq_file *m, void *v)
 	u16 vlanMap;
 	dma_addr_t handle;
 	HvLpEvent_Rc hvrc;
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 	struct device_node *node;
 	const char *sysid;
 
-- 
1.6.3.3

