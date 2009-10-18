Return-Path: <linux-kernel-owner+w=401wt.eu-S932085AbZJRW4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbZJRW4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:56:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZJRW4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:56:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:37675 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbZJRW4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:56:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=vJeIW48O4RcMpqStV4P7RiPSH6wUBVIWGcuzr0u+SGUgr9M6ap5hLHLygIOhvciVvy
         ofZWBFkSE2o2UK1WLVIZwbicXeSN9UOMxYSYKw3h7MItbYvn5NbZI/ft7sQc8ZF9sNDV
         dOZH6Xx5+08otHnGkKiTCygH8BcPDexWX6B44=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/7] ipc: fix trivial warning
Date: Mon, 19 Oct 2009 01:54:29 +0300
Message-Id: <1255906474-25091-3-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a0d092f introduced the following warning:
ipc/msg.c: In function ‘msgctl_down’:
ipc/msg.c:415: warning: ‘msqid64’ may be used uninitialized in this function

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 ipc/msg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 2ceab7f..085bd58 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -412,7 +412,7 @@ static int msgctl_down(struct ipc_namespace *ns, int msqid, int cmd,
 		       struct msqid_ds __user *buf, int version)
 {
 	struct kern_ipc_perm *ipcp;
-	struct msqid64_ds msqid64;
+	struct msqid64_ds uninitialized_var(msqid64);
 	struct msg_queue *msq;
 	int err;
 
-- 
1.6.5.1

