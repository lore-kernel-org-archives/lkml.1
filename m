Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZLKFeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZLKFeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZLKFdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:33:35 -0500
Received: from kroah.org ([198.145.64.141]:53530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbZLKF35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:57 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:51 2009
Message-Id: <20091211052551.004437667@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [20/34] ext4: make "norecovery" an alias for "noload"
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0016-ext4-make-norecovery-an-alias-for-noload.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit e3bb52ae2bb9573e84c17b8e3560378d13a5c798)

Users on the linux-ext4 list recently complained about differences
across filesystems w.r.t. how to mount without a journal replay.

In the discussion it was noted that xfs's "norecovery" option is
perhaps more descriptively accurate than "noload," so let's make
that an alias for ext4.

Also show this status in /proc/mounts

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/filesystems/ext4.txt |    4 ++--
 fs/ext4/super.c                    |    4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/filesystems/ext4.txt
+++ b/Documentation/filesystems/ext4.txt
@@ -153,8 +153,8 @@ journal_dev=devnum	When the external jou
 			identified through its new major/minor numbers encoded
 			in devnum.
 
-noload			Don't load the journal on mounting.  Note that
-                     	if the filesystem was not unmounted cleanly,
+norecovery		Don't load the journal on mounting.  Note that
+noload			if the filesystem was not unmounted cleanly,
                      	skipping the journal replay will lead to the
                      	filesystem containing inconsistencies that can
                      	lead to any number of problems.
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -902,6 +902,9 @@ static int ext4_show_options(struct seq_
 	if (test_opt(sb, DISCARD))
 		seq_puts(seq, ",discard");
 
+	if (test_opt(sb, NOLOAD))
+		seq_puts(seq, ",norecovery");
+
 	ext4_show_quota_options(seq, sb);
 
 	return 0;
@@ -1108,6 +1111,7 @@ static const match_table_t tokens = {
 	{Opt_acl, "acl"},
 	{Opt_noacl, "noacl"},
 	{Opt_noload, "noload"},
+	{Opt_noload, "norecovery"},
 	{Opt_nobh, "nobh"},
 	{Opt_bh, "bh"},
 	{Opt_commit, "commit=%u"},


