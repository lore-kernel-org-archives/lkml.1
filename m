Return-Path: <linux-kernel-owner+w=401wt.eu-S1763586AbYEFI45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763586AbYEFI45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761100AbYEFIuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:50:52 -0400
Received: from smtp.nokia.com ([192.100.122.230]:45168 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671AbYEFIuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:50:17 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       "Artem Bityutskiy" <Artem.Bityutskiy@nokia.com>
Subject: [PATCH take 2 02/28] do_mounts: allow UBI root device name
Date: Tue,  6 May 2008 13:35:33 +0300
Message-Id: <1210070159-22794-3-git-send-email-Artem.Bityutskiy@nokia.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com>
X-OriginalArrivalTime: 06 May 2008 08:49:50.0558 (UTC) FILETIME=[25296FE0:01C8AF56]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <ext-adrian.hunter@nokia.com>

Similarly to MTD devices, allow UBI devices.

Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 init/do_mounts.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 3885e70..f76bd2f 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -347,7 +347,8 @@ void __init prepare_namespace(void)
 
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

