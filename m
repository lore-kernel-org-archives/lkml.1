Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYLPPw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYLPPw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbYLPPwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:52:07 -0500
Received: from kumera.dghda.com ([80.68.90.171]:53418 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913AbYLPPwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:52:06 -0500
From: "Duane Griffin" <duaneg@dghda.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: [PATCH 0/8, v3] ensure symlinks are NUL-terminated
Date: Tue, 16 Dec 2008 15:51:52 +0000
Message-Id: <1229442720-31056-1-git-send-email-duaneg@dghda.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix potential bugs associated with link target handling by
NUL-terminating names read from disk.

This is version 3 of these patches. It fixes the bug, pointed out by Al Viro
and Evgeniy Dushistov, that i_size was not being validated. In order to
facilitate this it introduces a helper function for terminating the link name,
as suggested by Al.

diffstat:
 fs/ext2/inode.c          |    7 +++++--
 fs/ext3/inode.c          |    7 +++++--
 fs/ext4/inode.c          |    7 +++++--
 fs/freevxfs/vxfs_inode.c |    4 +++-
 fs/namei.c               |    7 +++++--
 fs/sysv/inode.c          |    6 +++++-
 fs/ufs/inode.c           |    8 ++++++--
 include/linux/namei.h    |    5 +++++
 8 files changed, 39 insertions(+), 12 deletions(-)
