Return-Path: <linux-kernel-owner+w=401wt.eu-S1755760AbYANBqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760AbYANBqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 20:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYANBpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 20:45:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbYANBpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 20:45:45 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 Jan 2008 12:45:37 +1100
Message-Id: <1080114014537.20371@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 6] md: Change a few 'int' to 'size_t' in md
References: <20080114123726.19968.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As suggested by Andrew Morton.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-01-14 12:24:17.000000000 +1100
+++ ./drivers/md/md.c	2008-01-14 12:24:31.000000000 +1100
@@ -1802,7 +1802,7 @@ static ssize_t
 state_show(mdk_rdev_t *rdev, char *page)
 {
 	char *sep = "";
-	int len=0;
+	size_t len = 0;
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		len+= sprintf(page+len, "%sfaulty",sep);
@@ -2320,7 +2320,7 @@ level_show(mddev_t *mddev, char *page)
 static ssize_t
 level_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	int rv = len;
+	ssize_t rv = len;
 	if (mddev->pers)
 		return -EBUSY;
 	if (len == 0)
@@ -2807,7 +2807,7 @@ metadata_store(mddev_t *mddev, const cha
 		return len;
 	}
 	if (strncmp(buf, "external:", 9) == 0) {
-		int namelen = len-9;
+		size_t namelen = len-9;
 		if (namelen >= sizeof(mddev->metadata_type))
 			namelen = sizeof(mddev->metadata_type)-1;
 		strncpy(mddev->metadata_type, buf+9, namelen);
