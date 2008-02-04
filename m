Return-Path: <linux-kernel-owner+w=401wt.eu-S1757435AbYBDTJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbYBDTJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbYBDTJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:09:05 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54187 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbYBDTJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:09:03 -0500
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: ocfs2-devel@oss.oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Move /sys/o2cb to /sys/fs/o2cb
Date: Mon,  4 Feb 2008 11:07:40 -0800
Message-Id: <1202152062-28370-1-git-send-email-mark.fasheh@oracle.com>
X-Mailer: git-send-email 1.5.3.4
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

	The following two patches move /sys/o2cb into /sys/fs/o2cb as we
previously discussed. A symlink is created to maintain compatibility with
existing versions of ocfs2-tools. A patch to automatically search
/sys/fs/o2cb has been committed to the ocfs2-tools repo and a release with
that code shouldn't be too far out. Old versions of ocfs2-tools have been
tested and work fine with the symlink there. The development version of
ocfs2-tools with the patch to search /sys/fs/o2cb has also been tested with
and without the symlink. All results are as expected - the new ocfs2-tools
works great with both setups.

	Documentation of the o2cb directory has been added so that future
hackers will have an easier time understanding what it's all about. The
/sys/o2cb symlink has been appropariately marked as going away in two years
- a timeline which we feel is appropriately long enough such that a very
small number of people would be affected by it's removal.

	The first patch fixes a small problem with sysfs_remove_link() which
I encountered while coding this all up. The 2nd one actually moves the
directory, creates the symlink and adds the appropriate documentation.

	Please review, and if all goes well, indicate to me when you'd be
comfortable with the small sysfs patch going upstream - I'd like to get this
series out there asap as it's a fairly trivial change, and some of the ocfs2
changes might conflict with our ongoing cluster stack rework.
	--Mark

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
