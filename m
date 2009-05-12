Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZELTQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZELTQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbZELTPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:15:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37728 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZELTPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:15:38 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] IMA: do not measure everything opened by root by default
To: zohar@linux.vnet.ibm.com
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org
Date: Tue, 12 May 2009 15:14:23 -0400
Message-ID: <20090512191423.6903.37464.stgit@dhcp231-142.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IMA default policy measures every single file opened by root.  This is
terrible for most users.  Consider a system (like mine) with virtual machine
images.  When those images are touched (which happens at boot for me) those
images are measured.  This is just way too much for the default case.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/integrity/ima/ima_policy.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index b168c1d..dec6dcb 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -61,8 +61,6 @@ static struct ima_measure_rule_entry default_rules[] = {
 	 .flags = IMA_FUNC | IMA_MASK},
 	{.action = MEASURE,.func = BPRM_CHECK,.mask = MAY_EXEC,
 	 .flags = IMA_FUNC | IMA_MASK},
-	{.action = MEASURE,.func = PATH_CHECK,.mask = MAY_READ,.uid = 0,
-	 .flags = IMA_FUNC | IMA_MASK | IMA_UID}
 };
 
 static LIST_HEAD(measure_default_rules);

