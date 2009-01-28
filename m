Return-Path: <linux-kernel-owner+w=401wt.eu-S1754641AbZA1GIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbZA1GIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZA1GHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:07:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:35685 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZA1GHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:07:50 -0500
From: Kumar Gala <galak@kernel.crashing.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: jeff@garzik.org, rjw@sisk.pl, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dmi: Fix build breakage
Date: Wed, 28 Jan 2009 00:07:20 -0600
Message-Id: <1233122840-24142-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduced:

commit d7b1956fed33d30c4815e848fd7a143722916868
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Mon Jan 19 20:55:50 2009 +0100

    DMI: Introduce dmi_first_match to make the interface more flexible

compile errors like the following when !CONFIG_DMI

    drivers/ata/sata_sil.c: In function 'sil_broken_system_poweroff':
    drivers/ata/sata_sil.c:713: error: implicit declaration of function 'dmi_first_match'
    drivers/ata/sata_sil.c:713: warning: initialization makes pointer from integer without a cast

We just need a dummy version of dmi_first_match() to fix this all up.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

This should supercede the driver specific patches I posted earlier.

- k

 include/linux/dmi.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmi.h b/include/linux/dmi.h
index aea2310..d741b9c 100644
--- a/include/linux/dmi.h
+++ b/include/linux/dmi.h
@@ -65,6 +65,8 @@ static inline int dmi_walk(void (*decode)(const struct dmi_header *))
 	{ return -1; }
 static inline bool dmi_match(enum dmi_field f, const char *str)
 	{ return false; }
+static inline const struct dmi_system_id *
+	dmi_first_match(const struct dmi_system_id *list) { return NULL; }
 
 #endif
 
-- 
1.5.6.6

