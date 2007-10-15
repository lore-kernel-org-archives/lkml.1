Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXJOEf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXJOEf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbXJOEeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:34:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:33142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbXJOEeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:34:44 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Oct 2007 14:34:37 +1000
Message-Id: <1071015043437.5489@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Iustin Pop <iusty@k1024.org>
Subject: [PATCH 003 of 5] md: Expose the degraded status of an assembled array through sysfs
References: <20071015143136.5200.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Iustin Pop <iusty@k1024.org>

The 'degraded' attribute is useful to quickly determine if the array is
degraded, instead of parsing 'mdadm -D' output or relying on the other
techniques (number of working devices against number of defined devices, etc.).
The md code already keeps track of this attribute, so it's useful to export it.

Signed-off-by: Iustin Pop <iusty@k1024.org>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-10-15 14:06:32.000000000 +1000
+++ ./drivers/md/md.c	2007-10-15 14:06:52.000000000 +1000
@@ -2833,6 +2833,12 @@ sync_max_store(mddev_t *mddev, const cha
 static struct md_sysfs_entry md_sync_max =
 __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
 
+static ssize_t
+degraded_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%d\n", mddev->degraded);
+}
+static struct md_sysfs_entry md_degraded = __ATTR_RO(degraded);
 
 static ssize_t
 sync_speed_show(mddev_t *mddev, char *page)
@@ -2976,6 +2982,7 @@ static struct attribute *md_redundancy_a
 	&md_suspend_lo.attr,
 	&md_suspend_hi.attr,
 	&md_bitmap.attr,
+	&md_degraded.attr,
 	NULL,
 };
 static struct attribute_group md_redundancy_group = {
