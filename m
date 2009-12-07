Return-Path: <linux-kernel-owner+w=401wt.eu-S934973AbZLGNUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973AbZLGNUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934605AbZLGNUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:20:33 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54846 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067AbZLGNUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:20:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=G6+kGtUfq3H0s5icVAyvFlMeXPUwHCHfzd7GgI5PIpxwpVUUgGJvuel7n6Jn+vjtkD
         Iw942Iht1l7Ahu9Iby6w6cN9eDYo8edvNl84qNFTK67PUw4O5ZsBWe4wDR1HJin8P8Ju
         acEhM9Vtv9BHVZLhGQSs1kOg2EefaXOMD01tY=
Message-ID: <4B1D0169.3040507@gmail.com>
Date: Mon, 07 Dec 2009 14:21:45 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@infradead.org>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] UBIFS: PTR_ERR return of wrong pointer in check_leaf()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the PTR_ERR of the correct pointer.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/ubifs/debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index dbc093a..8a771c5 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2014,7 +2014,7 @@ static int check_leaf(struct ubifs_info *c, struct ubifs_zbranch *zbr,
 		inum = key_inum_flash(c, &dent->key);
 		fscki1 = read_add_inode(c, priv, inum);
 		if (IS_ERR(fscki1)) {
-			err = PTR_ERR(fscki);
+			err = PTR_ERR(fscki1);
 			ubifs_err("error %d while processing entry node and "
 				  "trying to find parent inode node %lu",
 				  err, (unsigned long)inum);
