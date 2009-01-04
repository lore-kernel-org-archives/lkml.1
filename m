Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZADWcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZADWcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbZADWcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:32:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32819 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbZADWcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:32:35 -0500
Date: Sun, 4 Jan 2009 23:34:33 +0100
From: Pavel Machek <pavel@suse.cz>
To: Theodore Tso <tytso@mit.edu>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: [patch] document ext3 a bit better
Message-ID: <20090104223433.GC1913@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <20090104023211.GJ4758@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104023211.GJ4758@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ext3 has quite unexpected semantics or "ro" and defaults are usually
not what they are documented to be, due to mkfs override.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/Documentation/filesystems/ext3.txt b/Documentation/filesystems/ext3.txt
index 9dd2a3b..113db1f 100644
--- a/Documentation/filesystems/ext3.txt
+++ b/Documentation/filesystems/ext3.txt
@@ -14,6 +14,11 @@ Options
 When mounting an ext3 filesystem, the following option are accepted:
 (*) == default
 
+ro			Mount filesystem read only. Note that ext3 will replay
+			the journal (and thus write to the partition) even when
+			mounted "read only". "ro, noload" can be used to prevent
+			writes to the filesystem.
+
 journal=update		Update the ext3 file system's journal to the current
 			format.
 
@@ -27,7 +32,9 @@ journal_dev=devnum	When the external jou
 			identified through its new major/minor numbers encoded
 			in devnum.
 
-noload			Don't load the journal on mounting.
+noload			Don't load the journal on mounting. Note that this forces
+			mount of inconsistent filesystem, which can lead to
+			various problems.
 
 data=journal		All data are committed into the journal prior to being
 			written into the main file system.
@@ -95,6 +102,8 @@ debug			Extra debugging information is s
 errors=remount-ro(*)	Remount the filesystem read-only on an error.
 errors=continue		Keep going on a filesystem error.
 errors=panic		Panic and halt the machine if an error occurs.
+			(Note that default is overriden by superblock
+			setting on most systems).
 
 data_err=ignore(*)	Just print an error message if an error occurs
 			in a file data buffer in ordered mode.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
