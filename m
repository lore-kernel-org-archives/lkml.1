Return-Path: <linux-kernel-owner+w=401wt.eu-S1762836AbXKCAIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762836AbXKCAIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761764AbXKCABm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:01:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761710AbXKCABl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:01:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 24/54] kset: move /sys/slab to /sys/kernel/slab
Date: Fri,  2 Nov 2007 16:59:02 -0700
Message-Id: <1194047972-9850-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071102235758.GA9803@kroah.com>
References: <20071102235758.GA9803@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/sys/kernel is where these things should go.
Also updated the documentation and tool that used this directory.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/vm/slabinfo.c |    2 +-
 Documentation/vm/slub.txt   |    2 +-
 mm/slub.c                   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index 7047696..488c1f3 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -1021,7 +1021,7 @@ void read_slab_dir(void)
 	char *t;
 	int count;
 
-	if (chdir("/sys/slab"))
+	if (chdir("/sys/kernel/slab"))
 		fatal("SYSFS support for SLUB not active\n");
 
 	dir = opendir(".");
diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
index d17f324..dcf8bcf 100644
--- a/Documentation/vm/slub.txt
+++ b/Documentation/vm/slub.txt
@@ -63,7 +63,7 @@ In case you forgot to enable debugging on the kernel command line: It is
 possible to enable debugging manually when the kernel is up. Look at the
 contents of:
 
-/sys/slab/<slab name>/
+/sys/kernel/slab/<slab name>/
 
 Look at the writable files. Writing 1 to them will enable the
 corresponding debug option. All options can be set on a slab that does
diff --git a/mm/slub.c b/mm/slub.c
index 9957683..3700ec6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4109,7 +4109,7 @@ static int __init slab_sysfs_init(void)
 	int err;
 
 	slab_kset = kset_create_and_register("slab", &slab_uevent_ops,
-					     NULL, NULL);
+					     NULL, kernel_kset);
 	if (IS_ERR(slab_kset)) {
 		printk(KERN_ERR "Cannot register slab subsystem.\n");
 		return PTR_ERR(slab_kset);
-- 
1.5.3.4

