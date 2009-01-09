Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbZAIXkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbZAIXkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759766AbZAIXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:39:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:52863 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbZAIXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:39:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:from:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=RvJkg+ZDwFqUAkvflYlszAfN0KMGB87qFmI+LkvZQyPgZmqo1k0yi2v4nbxmbIZuLk
         QOdIRoQg9dT3mC+LmaITknk9KNZk3MUcEYNvkQNh9IRJHgUu8pm7W9ZSG7X+4cKGZy97
         PwPaZsN95RZMFn8Ssi358rk+lNoZITWJ7jZvc=
Subject: [PATCH 3/5] Fix dubious bitwise 'and' usage spotted by sparse.
To: LKML <linux-kernel@vger.kernel.org>
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Trivial Kernel Patches <trivial@kernel.org>
Date: Sat, 10 Jan 2009 02:48:13 +0300
Message-ID: <20090109234813.11800.84518.stgit@zaytsev.su>
In-Reply-To: <20090109234113.11800.55672.stgit@zaytsev.su>
References: <20090109234113.11800.55672.stgit@zaytsev.su>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't change the semantics, but it looks like
the logical 'and' was meant to be used here.
---
 drivers/media/video/gspca/m5602/m5602_s5k4aa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
index 14b1eac..c3ebcca 100644
--- a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
+++ b/drivers/media/video/gspca/m5602/m5602_s5k4aa.c
@@ -114,7 +114,7 @@ int s5k4aa_read_sensor(struct sd *sd, const u8 address,
 	if (err < 0)
 		goto out;
 
-	for (i = 0; (i < len) & !err; i++) {
+	for (i = 0; (i < len) && !err; i++) {
 		err = m5602_read_bridge(sd, M5602_XB_I2C_DATA, &(i2c_data[i]));
 
 		PDEBUG(D_CONF, "Reading sensor register "

