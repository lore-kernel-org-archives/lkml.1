Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZHSQH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZHSQH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZHSQHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:07:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZHSQEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:45 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org
Subject: [PATCH 0/17] Make O_SYNC handling use standard syncing path
Date: Wed, 19 Aug 2009 18:04:27 +0200
Message-Id: <1250697884-22288-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  below comes a patch series that unifies O_SYNC handling with code doing
fsync(). After this, we have just one place forcing a single file to disk so
filesystems like ext3 / ext4 don't have to force a transaction commit in
ext?_file_write for O_SYNC files / IS_SYNC inodes.
  The code is also cleaner this way (actually about 150 lines shorter), we
don't sync the inode several times as it happened previously etc.
  The patchset touches quite some filesystems. Hopefully I've added all the
relevant people to CC for the relevant patches. I've tested via blktrace that
for ext?, xfs, ocfs2 and fat, the file is indeed forced to disk as expected.
Maintainers of pohmelfs and NTFS might want to check that everything works
as expected for them after applying the patches.
  Comments / review welcome.

								Honza
