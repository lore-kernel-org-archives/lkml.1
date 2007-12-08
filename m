Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbXLHUz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbXLHUz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXLHUzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:55:19 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:52224 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbXLHUzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:55:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=ka7TnltePsH3CgzH8juIAdLofgjyfDSYqHYmpZiHi0er7oeQpg/Ui9v8L7MJR8b3MhLJOQY717iafVz5CVm9WWfJ9ipWfIsJxqcYdh86m5m2okflQqNGzTRBdgqT9AiHwD9pD5/9KN95ff6zM+uqAG+bKmQOV7DmWWBKSeJP+M4=
Date: Sat, 8 Dec 2007 21:56:20 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sound/core/seq: move declarations of globally visible
	variables to proper headers
Message-ID: <20071208205616.GI5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/core/seq: move declarations of globally visible variables to proper headers

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/core/seq/seq_clientmgr.c |    2 --
 sound/core/seq/seq_clientmgr.h |    2 ++
 sound/core/seq/seq_timer.c     |    7 -------
 sound/core/seq/seq_timer.h     |    7 +++++++
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 2e3fa25..048ad5a 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -130,8 +130,6 @@ static struct snd_seq_client *clientptr(int clientid)
 	return clienttab[clientid];
 }

-extern int seq_client_load[];
-
 struct snd_seq_client *snd_seq_client_use_ptr(int clientid)
 {
 	unsigned long flags;
diff --git a/sound/core/seq/seq_clientmgr.h b/sound/core/seq/seq_clientmgr.h
index 5e04e20..20f0a72 100644
--- a/sound/core/seq/seq_clientmgr.h
+++ b/sound/core/seq/seq_clientmgr.h
@@ -98,4 +98,6 @@ int snd_seq_kernel_client_write_poll(int clientid, struct file *file, poll_table
 int snd_seq_client_notify_subscription(int client, int port,
 				       struct snd_seq_port_subscribe *info, int evtype);

+extern int seq_client_load[15];
+
 #endif
diff --git a/sound/core/seq/seq_timer.c b/sound/core/seq/seq_timer.c
index 8716352..82a5b33 100644
--- a/sound/core/seq/seq_timer.c
+++ b/sound/core/seq/seq_timer.c
@@ -27,13 +27,6 @@
 #include "seq_queue.h"
 #include "seq_info.h"

-extern int seq_default_timer_class;
-extern int seq_default_timer_sclass;
-extern int seq_default_timer_card;
-extern int seq_default_timer_device;
-extern int seq_default_timer_subdevice;
-extern int seq_default_timer_resolution;
-
 /* allowed sequencer timer frequencies, in Hz */
 #define MIN_FREQUENCY		10
 #define MAX_FREQUENCY		6250
diff --git a/sound/core/seq/seq_timer.h b/sound/core/seq/seq_timer.h
index e9ee154..88dfb71 100644
--- a/sound/core/seq/seq_timer.h
+++ b/sound/core/seq/seq_timer.h
@@ -138,4 +138,11 @@ int snd_seq_timer_set_skew(struct snd_seq_timer *tmr, unsigned int skew, unsigne
 snd_seq_real_time_t snd_seq_timer_get_cur_time(struct snd_seq_timer *tmr);
 snd_seq_tick_time_t snd_seq_timer_get_cur_tick(struct snd_seq_timer *tmr);

+extern int seq_default_timer_class;
+extern int seq_default_timer_sclass;
+extern int seq_default_timer_card;
+extern int seq_default_timer_device;
+extern int seq_default_timer_subdevice;
+extern int seq_default_timer_resolution;
+
 #endif
