Return-Path: <linux-kernel-owner+w=401wt.eu-S1763922AbXGSJ6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763922AbXGSJ6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXGSJyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:54:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbXGSJyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:54:51 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: rientjes@google.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/58] x86_64: Use LOCAL_DISTANCE and  REMOTE_DISTANCE in x86_64 ACPI code
Message-Id: <20070719095450.26FD614E04@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:54:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: David Rientjes <rientjes@google.com>

Use LOCAL_DISTANCE and  REMOTE_DISTANCE in x86_64 ACPI code

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86_64/mm/srat.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/mm/srat.c
===================================================================
--- linux.orig/arch/x86_64/mm/srat.c
+++ linux/arch/x86_64/mm/srat.c
@@ -106,9 +106,9 @@ static __init int slit_valid(struct acpi
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
 			if (i == j) {
-				if (val != 10)
+				if (val != LOCAL_DISTANCE)
 					return 0;
-			} else if (val <= 10)
+			} else if (val <= LOCAL_DISTANCE)
 				return 0;
 		}
 	}
@@ -464,7 +464,7 @@ int __node_distance(int a, int b)
 	int index;
 
 	if (!acpi_slit)
-		return a == b ? 10 : 20;
+		return a == b ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	index = acpi_slit->locality_count * node_to_pxm(a);
 	return acpi_slit->entry[index + node_to_pxm(b)];
 }
