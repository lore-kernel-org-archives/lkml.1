Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZHYW1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZHYW1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbZHYW1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:27:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40569 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbZHYW1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:27:32 -0400
Date: Wed, 26 Aug 2009 00:27:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: [patch] document that ext2 can't handle barriers
Message-ID: <20090825222723.GC4300@elf.ucw.cz>
References: <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825161110.GP17684@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document things ext2 expects from storage filesystems, and the fact
that it can not handle barriers. Also remove jounaling description, as
that's really ext3 material.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/Documentation/filesystems/ext2.txt b/Documentation/filesystems/ext2.txt
index 67639f9..e300ca8 100644
--- a/Documentation/filesystems/ext2.txt
+++ b/Documentation/filesystems/ext2.txt
@@ -338,27 +339,17 @@ enough 4-character names to make up unique directory entries, so they
 have to be 8 character filenames, even then we are fairly close to
 running out of unique filenames.
 
+Requirements
+============
+
+Ext2 expects disk/storage subsystem not to return write errors.
+
+It also needs write caching to be disabled for reliable fsync
+operation; ext2 does not know how to issue barriers as of
+2.6.31. hdparm -W0 disables it on SATA disks.
+
 Journaling
-----------
-
-A journaling extension to the ext2 code has been developed by Stephen
-Tweedie.  It avoids the risks of metadata corruption and the need to
-wait for e2fsck to complete after a crash, without requiring a change
-to the on-disk ext2 layout.  In a nutshell, the journal is a regular
-file which stores whole metadata (and optionally data) blocks that have
-been modified, prior to writing them into the filesystem.  This means
-it is possible to add a journal to an existing ext2 filesystem without
-the need for data conversion.
-
-When changes to the filesystem (e.g. a file is renamed) they are stored in
-a transaction in the journal and can either be complete or incomplete at
-the time of a crash.  If a transaction is complete at the time of a crash
-(or in the normal case where the system does not crash), then any blocks
-in that transaction are guaranteed to represent a valid filesystem state,
-and are copied into the filesystem.  If a transaction is incomplete at
-the time of the crash, then there is no guarantee of consistency for
-the blocks in that transaction so they are discarded (which means any
-filesystem changes they represent are also lost).
+==========
 Check Documentation/filesystems/ext3.txt if you want to read more about
 ext3 and journaling.
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
