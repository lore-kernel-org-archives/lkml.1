Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZCSFN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZCSFN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 01:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZCSFMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 01:12:53 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:38680 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZCSFMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 01:12:51 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #3 0/2] 'debug' module parm and /sys/fs/aufs entries
Date: Thu, 19 Mar 2009 14:12:43 +0900
Message-Id: <1237439565-25039-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some entires under /sys/fs/aufs still print an abosule path. While sysfs
(and procfs?) limits the length of an entry upto PAGE_SIZE, the abs path
can be any length. I don't think it is important to support longer path
than PAGE_SIZE, so aufs simply returns -EFBIG (regardless this patch).

Following the comments from Greg KH, split /sys/fs/aufs/si_<id>/xino
into some files in order to keep "one value per file".

J. R. Okajima (2):
  replace /sys/fs/aufs/debug by /sys/module/aufs/parmaters/debug
  split 'xino' entry under sysfs

 Documentation/ABI/testing/sysfs-aufs  |   62 ++++++++
 Documentation/filesystems/aufs/aufs.5 |    8 +
 fs/aufs/branch.h                      |    6 +
 fs/aufs/debug.c                       |    4 +-
 fs/aufs/debug.h                       |   12 +-
 fs/aufs/sysaufs.c                     |    6 +-
 fs/aufs/sysaufs.h                     |   13 +-
 fs/aufs/sysfs.c                       |  260 ++++++++++++++++-----------------
 8 files changed, 224 insertions(+), 147 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-aufs

