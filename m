Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552Ab0AKUxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0AKUxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 15:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524Ab0AKUwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 15:52:21 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33567 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0AKUwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 15:52:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uHAXi7VGANg4ypLRqT73dFf2bL5Abn24TP9bcq6eknYsFtqRlDx21r8K6XanIIrdj/
         2I5PS3GwRBK/S4VJLXN0tDo0QLKFeBEsrLrGh8/UGzKTuiafTFhUheECccdAvIwIDU5t
         kxlk0sMDB0QKUTFn5ft2e4WhvKyrmVyovYaQA=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: John Kacur <jkacur@redhat.com>
Subject: [PATCH 12/15] s5k3e2fx: Convert the semaphore mess
Date: Mon, 11 Jan 2010 21:51:51 +0100
Message-Id: <1263243114-3942-13-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263243114-3942-12-git-send-email-jkacur@redhat.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_MUTEX(_LOCKED) and DECLARE_MUTEX are going away.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/staging/dream/camera/s5k3e2fx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/dream/camera/s5k3e2fx.c b/drivers/staging/dream/camera/s5k3e2fx.c
index edba198..b0e3e1d 100644
--- a/drivers/staging/dream/camera/s5k3e2fx.c
+++ b/drivers/staging/dream/camera/s5k3e2fx.c
@@ -312,7 +312,7 @@ struct s5k3e2fx_i2c_reg_conf {
 
 static struct s5k3e2fx_ctrl *s5k3e2fx_ctrl;
 static DECLARE_WAIT_QUEUE_HEAD(s5k3e2fx_wait_queue);
-DECLARE_MUTEX(s5k3e2fx_sem);
+DEFINE_SEMAPHORE(s5k3e2fx_sem);
 
 static int s5k3e2fx_i2c_rxdata(unsigned short saddr, unsigned char *rxdata,
 	int length)
-- 
1.6.5.2

