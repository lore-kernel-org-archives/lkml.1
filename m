Return-Path: <linux-kernel-owner+w=401wt.eu-S933421AbXHWXn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbXHWXn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765049AbXHWXnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:43:20 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:55581 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762884AbXHWXnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:43:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=dG8Xqa7GvBw+0XgQCFhimOxRqpO5GSpko2oSuQDv0XgU7CEQII1/yq/K0kLrnZVWwm4576M/6sFZZS9dkpkARmvPhDK4aTsKEVaEondDkk37xqZl6UhmWrxaUSRnRbHPWx3frbbTi4IjbkkBs5+Q8Y7u4ft8HeQMWREum0MiezA=
Message-Id: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <Message-Id: <200708240135.56833.jesper.juhl@gmail.com>>
References: <Message-Id: <200708240135.56833.jesper.juhl@gmail.com>>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 01:40:26 +0200
Subject: [PATCH 01/30] ia64: Remove unnecessary cast of allocation return value in sn_hwperf_enum_objects()
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Mark Goodwin <markgw@sgi.com>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org, Jes Sorensen <jes@sgi.com>,
       linux-altix@sgi.com, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns a void pointer - no need to cast it.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 arch/ia64/sn/kernel/sn2/sn_hwperf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index df8d5be..1a8e496 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -66,7 +66,8 @@ static int sn_hwperf_enum_objects(int *nobj, struct sn_hwperf_object_info **ret)
 	}
 
 	sz = sn_hwperf_obj_cnt * sizeof(struct sn_hwperf_object_info);
-	if ((objbuf = (struct sn_hwperf_object_info *) vmalloc(sz)) == NULL) {
+	objbuf = vmalloc(sz);
+	if (objbuf == NULL) {
 		printk("sn_hwperf_enum_objects: vmalloc(%d) failed\n", (int)sz);
 		e = -ENOMEM;
 		goto out;
-- 
1.5.2.2

