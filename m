Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYIJTn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYIJTn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYIJTnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:43:06 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:59372 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYIJTnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:43:05 -0400
Date: Wed, 10 Sep 2008 21:42:52 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@suse.de>
cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: md: Check for memory allocation failure in faulty personality
Message-ID: <alpine.LNX.2.00.0809102132590.19109@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 10 Sep 2008 19:43:04 +0000
	Bayes: 0.4269 Tokens: new, 162; hammy, 5; neutral, 3; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4269]
X-Spam-Signature: dfb5a3a780ab497a1c0d74cf1ae6d9fd842b01b9
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a fault injection module, but I don't think we should oops here.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/md/faulty.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Other personalities return -EIO, when something like this happens, but I 
don't see a reason why we shouldn't return the more appropriate -ENOMEM 
here.

diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 268547d..f26c1f9 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -287,6 +287,8 @@ static int run(mddev_t *mddev)
 	int i;
 
 	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		return -ENOMEM;
 
 	for (i=0; i<Modes; i++) {
 		atomic_set(&conf->counters[i], 0);
