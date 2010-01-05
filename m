Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614Ab0AEAgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0AEAgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575Ab0AEAg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:36:26 -0500
Received: from kroah.org ([198.145.64.141]:42516 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab0AEAgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:36:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 92/97] amd64_edac: fix forcing module load/unload
Date: Mon,  4 Jan 2010 16:33:45 -0800
Message-Id: <1262651630-7354-92-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

commit 43f5e68733cfe8bed3c30b5c14c4993dffb29766 upstream.

Clear the override flag after force-loading the module.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/edac/amd64_edac.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 22910c6..a0bcfba 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2836,9 +2836,8 @@ static int amd64_check_ecc_enabled(struct amd64_pvt *pvt)
 			amd64_printk(KERN_WARNING, "%s", ecc_warning);
 			return -ENODEV;
 		}
-	} else
-		/* CLEAR the override, since BIOS controlled it */
 		ecc_enable_override = 0;
+	}
 
 	return 0;
 }
-- 
1.6.6

