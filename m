Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYBUXtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYBUXtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935852AbYBUXsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:45008 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765485AbYBUXsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/11] slabinfo: fall back from /sys/kernel/slab to /sys/slab
Date: Thu, 21 Feb 2008 15:47:58 -0800
Message-Id: <1203637687-7273-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

I keep running upstream and mm kernels and the location of the slab
directory is different since upstream still uses /sys/slab.  This patch
makes slabinfo check /sys/slab if /sys/kernel/slab is not there.  Makes
slabinfo work on any kernel.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/vm/slabinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/vm/slabinfo.c b/Documentation/vm/slabinfo.c
index 7123fee..22d7e3e 100644
--- a/Documentation/vm/slabinfo.c
+++ b/Documentation/vm/slabinfo.c
@@ -1123,7 +1123,7 @@ void read_slab_dir(void)
 	char *t;
 	int count;
 
-	if (chdir("/sys/kernel/slab"))
+	if (chdir("/sys/kernel/slab") && chdir("/sys/slab"))
 		fatal("SYSFS support for SLUB not active\n");
 
 	dir = opendir(".");
-- 
1.5.4

