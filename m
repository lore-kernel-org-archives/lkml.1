Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0AKUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0AKUwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309Ab0AKUwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:19 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:64054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab0AKUwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=IAmJJdzq/+e9ftG3/6UXwSME0/XSxlxZbnajtf0fKveXt9436fRbc4IG9Ca8RaKY6K
         bHmwbObtcIDNcTWFhQj5XcC94KIuQT5ovEs6uVF/mkVxc4XXmPJzPwkZFDc3lY/Fmrtm
         p+4ILyThG4h3Md5Wunyl0bWC0kAsfBsJuOIjg=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 09/15] mt9d112: Convert the semaphore mess.
Date: Mon, 11 Jan 2010 21:51:48 +0100
Message-Id: <1263243114-3942-10-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-9-git-send-email-jkacur@redhat.com>
References: <1263243114-3942-1-git-send-email-jkacur@redhat.com>
 <1263243114-3942-2-git-send-email-jkacur@redhat.com>
 <1263243114-3942-3-git-send-email-jkacur@redhat.com>
 <1263243114-3942-4-git-send-email-jkacur@redhat.com>
 <1263243114-3942-5-git-send-email-jkacur@redhat.com>
 <1263243114-3942-6-git-send-email-jkacur@redhat.com>
 <1263243114-3942-7-git-send-email-jkacur@redhat.com>
 <1263243114-3942-8-git-send-email-jkacur@redhat.com>
 <1263243114-3942-9-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/dream/camera/mt9d112.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/camera/mt9d112.c b/drivers/staging/dream/camera/mt9d112.c
index 4f938f9..4c21065 100644
--- a/drivers/staging/dream/camera/mt9d112.c
+++ b/drivers/staging/dream/camera/mt9d112.c
@@ -36,7 +36,7 @@ struct mt9d112_ctrl {
 static struct mt9d112_ctrl *mt9d112_ctrl;
 
 static DECLARE_WAIT_QUEUE_HEAD(mt9d112_wait_queue);
-DECLARE_MUTEX(mt9d112_sem);
+DEFINE_SEMAPHORE(mt9d112_sem);
 
 
 /*=============================================================
-- 
1.6.5.2

