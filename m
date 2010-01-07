Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311Ab0AGQlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab0AGQlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053Ab0AGQlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:41:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:14596 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0AGQk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Dod7W3C+YLY2QutM7t+vnBpC1AhViYgoGs7M6RU3T9hDgFNnV/hfc7I2LPqpTGaVV7
         GwGAwBJbTZuQxTOocEQgaGO41cVu4p7cZdPr28C/SwH8a6OBmZ1cIgSZUYHF3dexEx56
         4uVCZtG1pQjAX29si72uZ58UJQBO0TdmDY1Yc=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 2/2] perf: fix memory leak: counterwidth
Date: Thu,  7 Jan 2010 19:40:47 +0300
Message-Id: <1262882447-23776-2-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>
References: <1262882447-23776-1-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 tools/perf/util/values.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/values.c b/tools/perf/util/values.c
index 1c15e39..cfa55d6 100644
--- a/tools/perf/util/values.c
+++ b/tools/perf/util/values.c
@@ -169,6 +169,7 @@ static void perf_read_values__display_pretty(FILE *fp,
 				counterwidth[j], values->value[i][j]);
 		fprintf(fp, "\n");
 	}
+	free(counterwidth);
 }
 
 static void perf_read_values__display_raw(FILE *fp,
-- 
1.6.6

