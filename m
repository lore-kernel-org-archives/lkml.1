Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYEZMX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYEZMX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 08:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214AbYEZMX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 08:23:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49524 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbYEZMX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 08:23:28 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 3 03/29] do_mounts: allow UBI root device name
Date: Mon, 26 May 2008 17:05:17 +0300
Message-Id: <1211810743-18936-4-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1211810743-18936-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 26 May 2008 12:23:24.0214 (UTC) FILETIME=[4AF52D60:01C8BF2B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Similarly to MTD devices, allow UBI devices.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
---
 init/do_mounts.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 660c1e5..a1de1bf 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -372,7 +372,8 @@ void __init prepare_namespace(void)
 
 	if (saved_root_name[0]) {
 		root_device_name = saved_root_name;
-		if (!strncmp(root_device_name, "mtd", 3)) {
+		if (!strncmp(root_device_name, "mtd", 3) ||
+		    !strncmp(root_device_name, "ubi", 3)) {
 			mount_block_root(root_device_name, root_mountflags);
 			goto out;
 		}
-- 
1.5.4.1

