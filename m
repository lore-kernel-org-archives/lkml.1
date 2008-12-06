Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYLFW0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYLFW0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 17:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYLFWZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 17:25:52 -0500
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55362 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752850AbYLFWZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 17:25:51 -0500
Date: Sat, 6 Dec 2008 17:25:35 -0500
From: Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Harald Arnesen <skogtun.harald@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [ext4] Documentation patch
Message-ID: <20081206222534.GJ1323@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Harald Arnesen <skogtun.harald@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <8763m3u9kv.fsf@basilikum.skogtun.org> <20081201165700.GA26680@infradead.org> <493425DC.1010008@redhat.com> <20081201205828.GA20069@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201205828.GA20069@mit.edu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what I have added to the ext4 patch queue.

							- Ted

Update Documentation/filesystems/ext4.txt

Fix paragraph with recommendations on how to tune ext4 for benchmarks.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
diff --git a/Documentation/filesystems/ext4.txt b/Documentation/filesystems/ext4.txt
index 845e691..19bb93f 100644
--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -58,13 +58,18 @@ Note: More extensive information for getting started with ext4 can be
 
 	# mount -t ext4 /dev/hda1 /wherever
 
-  - When comparing performance with other filesystems, remember that
-    ext3/4 by default offers higher data integrity guarantees than most.
-    So when comparing with a metadata-only journalling filesystem, such
-    as ext3, use `mount -o data=writeback'.  And you might as well use
-    `mount -o nobh' too along with it.  Making the journal larger than
-    the mke2fs default often helps performance with metadata-intensive
-    workloads.
+  - When comparing performance with other filesystems, it's always
+    important to try multiple workloads; very often a subtle change in a
+    workload parameter can completely change the ranking of which
+    filesystems do well compared to others.  When comparing versus ext3,
+    note that ext4 enables write barriers by default, while ext3 does
+    not enable write barriers by default.  So it is useful to use
+    explicitly specify whether barriers are enabled or not when via the
+    '-o barriers=[0|1]' mount option.  When tuning ext3 for best
+    benchmark numbers, it is often worthwhile to try changing the data
+    journaling mode; '-o data=writeback,nobh' can be faster for some
+    workloads.  A large journal can also be helpful for
+    metadata-intensive workloads.
 
 2. Features
 ===========
