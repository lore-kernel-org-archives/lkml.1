Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbZLYUtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbZLYUtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 15:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZLYUtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 15:49:11 -0500
Received: from THUNK.ORG ([69.25.196.29]:35107 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756630AbZLYUtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 15:49:06 -0500
Date: Fri, 25 Dec 2009 15:48:59 -0500
From: tytso@mit.edu
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Yin, Kangkai" <kangkai.yin@intel.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: jbd-debug and jbd2-debug should be writable.
Message-ID: <20091225204859.GG32757@thunk.org>
Mail-Followup-To: tytso@mit.edu,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	"Yin, Kangkai" <kangkai.yin@intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
References: <20091204031735.GN19635@kai-debian>
 <20091204094932.GC4272@skywalker.linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091204094932.GC4272@skywalker.linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ext4 portion has been added to the ext4 patch queue.

Jan, you want to add this to the ext3 tree?

					- Ted

jbd: /sys/kernel/debug/jbd/jbd-debug should be writable.

From: "Yin, Kangkai" <kangkai.yin@intel.com>

Make this sysfs file writeable so we can enable debugging without
needing to reboot and futzing with boot command-line option.

Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd/journal.c  |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 4160afa..bd224ee 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1913,7 +1913,7 @@ static void __init jbd_create_debugfs_entry(void)
 {
 	jbd_debugfs_dir = debugfs_create_dir("jbd", NULL);
 	if (jbd_debugfs_dir)
-		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO,
+		jbd_debug = debugfs_create_u8("jbd-debug", S_IRUGO | S_IWUSR,
 					       jbd_debugfs_dir,
 					       &journal_enable_debug);
 }
