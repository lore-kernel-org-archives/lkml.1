Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbZHNUKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbZHNUKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbZHNUKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:10:03 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41542 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbZHNUKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:10:01 -0400
Date: Fri, 14 Aug 2009 22:10:00 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: gregkh@suse.de, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: Make some structures static
Message-ID: <Pine.LNX.4.64.0908142209231.31743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This was done using a semantic patch (http://coccinelle.lip6.fr/) that
checks that the declaration is not inside a function definition, that the
defined variable is not exported using EXPORTED_SYMBOL, etc, and that the
defined variable does not occur in any other file.  If these conditions
hold, static is added before the declaration.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/android/binder.c             |    4 ++--
 drivers/staging/dream/qdsp5/audio_aac.c      |    2 +-
 drivers/staging/dream/qdsp5/audio_in.c       |    2 +-
 drivers/staging/dream/qdsp5/audio_mp3.c      |    2 +-
 drivers/staging/dream/qdsp5/audio_out.c      |    2 +-
 drivers/staging/dream/smd/smd_rpcrouter.c    |    2 +-
 drivers/staging/otus/80211core/performance.c |    6 +++---
 drivers/staging/otus/hal/hpmain.c            |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff -u -p a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -164,8 +164,8 @@ struct binder_transaction_log {
 	int full;
 	struct binder_transaction_log_entry entry[32];
 };
-struct binder_transaction_log binder_transaction_log;
-struct binder_transaction_log binder_transaction_log_failed;
+static struct binder_transaction_log binder_transaction_log;
+static struct binder_transaction_log binder_transaction_log_failed;
 
 static struct binder_transaction_log_entry *binder_transaction_log_add(
 	struct binder_transaction_log *log)
diff -u -p a/drivers/staging/dream/qdsp5/audio_aac.c b/drivers/staging/dream/qdsp5/audio_aac.c
--- a/drivers/staging/dream/qdsp5/audio_aac.c
+++ b/drivers/staging/dream/qdsp5/audio_aac.c
@@ -950,7 +950,7 @@ static int audio_release(struct inode *i
 	return 0;
 }
 
-struct audio the_aac_audio;
+static struct audio the_aac_audio;
 
 static int audio_open(struct inode *inode, struct file *file)
 {
diff -u -p a/drivers/staging/dream/qdsp5/audio_in.c b/drivers/staging/dream/qdsp5/audio_in.c
--- a/drivers/staging/dream/qdsp5/audio_in.c
+++ b/drivers/staging/dream/qdsp5/audio_in.c
@@ -785,7 +785,7 @@ static int audio_in_release(struct inode
 	return 0;
 }
 
-struct audio_in the_audio_in;
+static struct audio_in the_audio_in;
 
 static int audio_in_open(struct inode *inode, struct file *file)
 {
diff -u -p a/drivers/staging/dream/qdsp5/audio_mp3.c b/drivers/staging/dream/qdsp5/audio_mp3.c
--- a/drivers/staging/dream/qdsp5/audio_mp3.c
+++ b/drivers/staging/dream/qdsp5/audio_mp3.c
@@ -864,7 +864,7 @@ static int audio_release(struct inode *i
 	return 0;
 }
 
-struct audio the_mp3_audio;
+static struct audio the_mp3_audio;
 
 static int audio_open(struct inode *inode, struct file *file)
 {
diff -u -p a/drivers/staging/dream/qdsp5/audio_out.c b/drivers/staging/dream/qdsp5/audio_out.c
--- a/drivers/staging/dream/qdsp5/audio_out.c
+++ b/drivers/staging/dream/qdsp5/audio_out.c
@@ -699,7 +699,7 @@ static int audio_release(struct inode *i
 	return 0;
 }
 
-struct audio the_audio;
+static struct audio the_audio;
 
 static int audio_open(struct inode *inode, struct file *file)
 {
diff -u -p a/drivers/staging/dream/smd/smd_rpcrouter.c b/drivers/staging/dream/smd/smd_rpcrouter.c
--- a/drivers/staging/dream/smd/smd_rpcrouter.c
+++ b/drivers/staging/dream/smd/smd_rpcrouter.c
@@ -122,7 +122,7 @@ struct rr_context {
 	uint32_t count; /* bytes needed in this state */
 };
 
-struct rr_context the_rr_context;
+static struct rr_context the_rr_context;
 
 static struct platform_device rpcrouter_pdev = {
 	.name		= "oncrpc_router",
diff -u -p a/drivers/staging/otus/80211core/performance.c b/drivers/staging/otus/80211core/performance.c
--- a/drivers/staging/otus/80211core/performance.c
+++ b/drivers/staging/otus/80211core/performance.c
@@ -27,9 +27,9 @@
 #ifdef ZM_ENABLE_PERFORMANCE_EVALUATION
 
 #define ZM_TP_SIZE 50
-struct zsSummary zm_summary;
-struct zsVariation zm_var;
-struct zsThroughput zm_tp;
+static struct zsSummary zm_summary;
+static struct zsVariation zm_var;
+static struct zsThroughput zm_tp;
 
 void zfiPerformanceInit(zdev_t* dev)
 {
diff -u -p a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -76,7 +76,7 @@ u32_t zfHpEchoCommand(zdev_t* dev, u32_t
 
 
 #define zm_hp_priv(x) (((struct zsHpPriv*)wd->hpPrivate)->x)
-struct zsHpPriv zgHpPriv;
+static struct zsHpPriv zgHpPriv;
 
 #define ZM_FIRMWARE_WLAN_ADDR           0x200000
 #define ZM_FIRMWARE_SPI_ADDR      0x114000
