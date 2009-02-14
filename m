Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZBNVfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZBNVfQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbZBNVfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:35:04 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:51625 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZBNVfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:35:02 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 20/43] drivers/net/hamradio: fix sparse warning: context
	imbalance
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:34:52 +0100
Message-ID: <20090214213329.24377.28382.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Attribute functions with __acquires(...) resp. __releases(...).

Fix this sparse warnings:
  drivers/net/hamradio/bpqether.c:387:13: warning: context imbalance in 'bpq_seq_start' - wrong count at exit
  drivers/net/hamradio/bpqether.c:419:13: warning: context imbalance in 'bpq_seq_stop' - unexpected unlock

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/hamradio/bpqether.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 723e9c1..44b183b 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -386,6 +386,7 @@ static int bpq_close(struct net_device *dev)
  *	Proc filesystem
  */
 static void *bpq_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(RCU)
 {
 	int i = 1;
 	struct bpqdev *bpqdev;
@@ -418,6 +419,7 @@ static void *bpq_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void bpq_seq_stop(struct seq_file *seq, void *v)
+	__releases(RCU)
 {
 	rcu_read_unlock();
 }

