Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400Ab0A2JZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab0A2JZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966Ab0A2JZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:25:33 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:46096 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab0A2JZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:25:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH -resend 1/1] EDAC: add __init to i7core_xeon_pci_fixup
Date: Fri, 29 Jan 2010 10:25:27 +0100
Message-Id: <1264757127-31993-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's called only from an __init function and is the only user
of pcibios_scan_specific_bus which shall be marked as __devinit
to resolve section mismatches.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 4de5a18..c7fc0d5 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1141,7 +1141,7 @@ static void i7core_put_all_devices(void)
 		i7core_put_devices(i7core_dev);
 }
 
-static void i7core_xeon_pci_fixup(int dev_id)
+static void __init i7core_xeon_pci_fixup(int dev_id)
 {
 	struct pci_dev *pdev = NULL;
 	int i;
-- 
1.6.6.1

