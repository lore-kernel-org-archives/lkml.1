Return-Path: <linux-kernel-owner+w=401wt.eu-S1759845AbYFZSGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845AbYFZSGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYFZSFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:05:52 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:41445 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYFZSFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:05:51 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [BUGFIX][PATCH 0/2] configfs: Fix cleanup after mkdir() failure
Date: Thu, 26 Jun 2008 20:05:47 +0200
Message-Id: <1214503549-15678-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [ applies on top of http://lkml.org/lkml/2008/6/23/145 aka symlink() fixes ]

Hi,

This patchset fixes two kinds of bugs happening when
configfs_attach_group()/configfs_attach_item() fail and userspace races with
mkdir() or symlink().

Please read the first patch header for a detailed scenario explaining the bugs.

Louis

Summary (2):
  configfs: Prevent userspace from creating new entries under attaching
    directories
  configfs: Lock new directory inodes before removing on cleanup after
    failure

 fs/configfs/configfs_internal.h |    1 +
 fs/configfs/dir.c               |  127 +++++++++++++++++++++++++++++++--------
 fs/configfs/symlink.c           |   17 +++++-
 3 files changed, 118 insertions(+), 27 deletions(-)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
