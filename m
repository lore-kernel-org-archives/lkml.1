Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYFQRhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYFQRhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 13:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbYFQRh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 13:37:26 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54289 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbYFQRhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 13:37:25 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel.Becker@oracle.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [BUGFIX][PATCH 0/3] configfs: symlink() fixes
Date: Tue, 17 Jun 2008 19:37:20 +0200
Message-Id: <1213724243-29183-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ applies on top of the previously submitted rename() vs rmdir() deadlock fix ]

Hi,

The following patchset fixes incorrect symlinks to dead items in configfs, which
are forbidden by specification.

The first patch actually prevents such dangling symlinks from being created, but
introduces a weird(?) behavior where a failing symlink() can make a racing
rmdir() fail in the symlink's parent and in the symlink's target as well. The
next patches prevent this behavior using a similar idea as for the mkdir() vs
rmdir() case previously submitted.

Summary:
  configfs: Fix symlink() to a removing item
  configfs: Rename CONFIGFS_USET_IN_MKDIR to CONFIGFS_USET_ATTACHING
  configfs: Fix failing symlink() making rmdir() fail

 fs/configfs/configfs_internal.h |    2 +-
 fs/configfs/dir.c               |   20 ++++++++++----------
 fs/configfs/symlink.c           |   33 +++++++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 15 deletions(-)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
