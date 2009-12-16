Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbZLPOge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbZLPOge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:36:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762152AbZLPOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:36:29 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56827 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762023AbZLPOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:36:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=pF4X80y2W0xnGQJij8IjaHNgqVGFRkkuNbJZzdSCpo58LFK93kwE7JP1h1mp4uoS9L
         xJSzbJZr2kqSOB0IhWqRxn9A8sphAmTRdQUgv+NLkJIrz/UBJ8DnDT0zSTqPIHSNbXCx
         UgD3RWr2wBeFBMqW6epp8fudVo5bVTUgobDjY=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stelian Pop <stelian@popies.net>,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: [PATCH 2/5] hwmon: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 22:35:58 +0800
Message-Id: <1260974161-6934-3-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1260974161-6934-2-git-send-email-yong.zhang0@gmail.com>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-2-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <linux-kernel@hansmi.ch>
---
 drivers/hwmon/ams/ams-pmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ams/ams-pmu.c b/drivers/hwmon/ams/ams-pmu.c
index fb18b3d..2016629 100644
--- a/drivers/hwmon/ams/ams-pmu.c
+++ b/drivers/hwmon/ams/ams-pmu.c
@@ -52,7 +52,7 @@ static void ams_pmu_req_complete(struct adb_request *req)
 static void ams_pmu_set_register(u8 reg, u8 value)
 {
 	static struct adb_request req;
-	DECLARE_COMPLETION(req_complete);
+	DECLARE_COMPLETION_ONSTACK(req_complete);
 
 	req.arg = &req_complete;
 	if (pmu_request(&req, ams_pmu_req_complete, 4, ams_pmu_cmd, 0x00, reg, value))
@@ -65,7 +65,7 @@ static void ams_pmu_set_register(u8 reg, u8 value)
 static u8 ams_pmu_get_register(u8 reg)
 {
 	static struct adb_request req;
-	DECLARE_COMPLETION(req_complete);
+	DECLARE_COMPLETION_ONSTACK(req_complete);
 
 	req.arg = &req_complete;
 	if (pmu_request(&req, ams_pmu_req_complete, 3, ams_pmu_cmd, 0x01, reg))
-- 
1.6.3.3

