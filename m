Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYFAOwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYFAOwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYFAOv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:51:59 -0400
Received: from atflat.net ([80.229.16.180]:40455 "EHLO holly.atflat.local"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751151AbYFAOv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:51:59 -0400
From: Tom Spink <tspink@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 0/2] On-demand Filesystem Initialisation
Date: Sun,  1 Jun 2008 15:51:53 +0100
Message-Id: <1212331915-22856-1-git-send-email-tspink@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(resend to include CCs)

This (short) patch series is another RFC for the patch that introduces on-demand
filesystem initialisation.  In addition to the original infrastructure
implementation (with clean-ups), it changes XFS to use this new infrastructure.

I wrote a toy filesystem (testfs) to simulate scheduling/allocation delays and
to torture the mount/unmount cycles.  I didn't manage to deadlock the system
in my tests.  XFS also works as expected aswell, in that the global threads
are not created until an XFS filesystem is mounted for the first time.  When the
last XFS filesystem is unmounted, the threads go away.

Please let me know what you think!

-- Tom

fs/filesystems.c             |    2 +
fs/super.c                   |   47 +++++++++++++++++++++++++++++++++++-
fs/xfs/linux-2.6/xfs_super.c |   55 +++++++++++++++++++++++-------------------
include/linux/fs.h           |    3 ++
4 files changed, 81 insertions(+), 26 deletions(-)
