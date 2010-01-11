Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570Ab0AKUwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab0AKUwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266Ab0AKUwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:39 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33567 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab0AKUwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jWYzcx55Z2WeXDoGcfgSHNZynk1VcpjZgOOURMfLjSjYKYlsDX3ZUHrpZUCcssW1nG
         negE6FOHcOMyJAHwb1uJsa0hLgaFn0mHoqmdfz7NMJc7FVgrpwUosyqBLmrfHo387fsh
         DhVun++CrAamdhPBvrEkPhXk5gOOdDj57f0oM=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 15/15] vme_user: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:54 +0100
Message-Id: <1263243114-3942-16-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-15-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
 <1263243114-3942-6-git-send-email-jkacur@redhat.com>
 <1263243114-3942-7-git-send-email-jkacur@redhat.com>
 <1263243114-3942-8-git-send-email-jkacur@redhat.com>
 <1263243114-3942-9-git-send-email-jkacur@redhat.com>
 <1263243114-3942-10-git-send-email-jkacur@redhat.com>
 <1263243114-3942-11-git-send-email-jkacur@redhat.com>
 <1263243114-3942-12-git-send-email-jkacur@redhat.com>
 <1263243114-3942-13-git-send-email-jkacur@redhat.com>
 <1263243114-3942-14-git-send-email-jkacur@redhat.com>
 <1263243114-3942-15-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/vme/devices/vme_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e228942..7cc609c 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -639,7 +639,7 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 	for (i = 0; i < VME_DEVS; i++) {
 		image[i].kern_buf = NULL;
 		image[i].pci_buf = 0;
-		init_MUTEX(&(image[i].sem));
+		semaphore_init(&(image[i].sem));
 		image[i].device = NULL;
 		image[i].resource = NULL;
 		image[i].users = 0;
-- 
1.6.5.2

