Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYGDO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYGDO4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 10:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbYGDO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 10:56:09 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54485 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYGDO4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:56:08 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: joel.becker@hawkmoon.kerlabs.com
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [BUGFIX][PATCH v2 0/2] configfs: Fix cleanup after mkdir() failure
Date: Fri,  4 Jul 2008 16:56:04 +0200
Message-Id: <1215183366-17479-1-git-send-email-louis.rilling@kerlabs.com>
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

Changelog:
  - Few code reworks as requested by Joel (details in patch headers)

Summary (2):
  configfs: Prevent userspace from creating new entries under attaching
    directories
  configfs: Lock new directory inodes before removing on cleanup after
    failure

 fs/configfs/configfs_internal.h |    2 +
 fs/configfs/dir.c               |  141 ++++++++++++++++++++++++++++++++-------
 fs/configfs/symlink.c           |   15 ++++
 3 files changed, 133 insertions(+), 25 deletions(-)

-- 
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
