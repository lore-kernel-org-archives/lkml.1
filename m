Return-Path: <linux-kernel-owner+w=401wt.eu-S1762475AbYD2LOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475AbYD2LOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbYD2LN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13319 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbYD2LNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:25 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Patrick McHardy <kaber@trash.net>
Subject: [PATCH 6/12] vlan: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:16 +0400
Message-Id: <1209467602-20001-6-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Patrick McHardy <kaber@trash.net>
---
 net/8021q/vlanproc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index daad006..08b54b5 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -176,12 +176,11 @@ int vlan_proc_add_dev(struct net_device *vlandev)
 	struct vlan_dev_info *dev_info = vlan_dev_info(vlandev);
 	struct vlan_net *vn = net_generic(dev_net(vlandev), vlan_net_id);
 
-	dev_info->dent = proc_create(vlandev->name, S_IFREG|S_IRUSR|S_IWUSR,
-				     vn->proc_vlan_dir, &vlandev_fops);
+	dev_info->dent =
+		proc_create_data(vlandev->name, S_IFREG|S_IRUSR|S_IWUSR,
+				 vn->proc_vlan_dir, &vlandev_fops, vlandev);
 	if (!dev_info->dent)
 		return -ENOBUFS;
-
-	dev_info->dent->data = vlandev;
 	return 0;
 }
 
-- 
1.5.3.rc5

