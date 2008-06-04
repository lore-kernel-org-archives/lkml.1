Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYFDHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYFDHqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYFDHqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:46:30 -0400
Received: from sacred.ru ([62.205.161.221]:37988 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbYFDHq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:46:29 -0400
Message-ID: <484645C1.6030108@openvz.org>
Date: Wed, 04 Jun 2008 11:35:29 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Serge Hallyn <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] devcgroup: make a helper to convert cgroup_subsys_state
 to devs_cgroup
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 04 Jun 2008 11:37:46 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just picking the container_of out of cgroup_to_devcgroup into
a separate function.

This new css_to_devcgroup will be used in the 2nd patch.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 security/device_cgroup.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 4ea5836..15f2f80 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -49,10 +49,14 @@ struct dev_cgroup {
 	spinlock_t lock;
 };
 
+static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
+{
+	return container_of(s, struct dev_cgroup, css);
+}
+
 static inline struct dev_cgroup *cgroup_to_devcgroup(struct cgroup *cgroup)
 {
-	return container_of(cgroup_subsys_state(cgroup, devices_subsys_id),
-			    struct dev_cgroup, css);
+	return css_to_devcgroup(cgroup_subsys_state(cgroup, devices_subsys_id));
 }
 
 struct cgroup_subsys devices_subsys;
-- 
1.5.3.4

