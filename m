Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbYCEW6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbYCEW6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764715AbYCEWwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:52:47 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:29579 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764611AbYCEWwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:52:31 -0500
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/7] ocfs2: Extended slot map
Date: Wed,  5 Mar 2008 14:51:57 -0800
Message-Id: <1204757524-21343-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.3.4
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ocfs2 has a system file called "slot_map".  A "slot" is a collection of
files local to particular mounted node, including the journal and
allocators that node is using.  The slot map converts the slot number to
a node number, so when a node dies, ocfs2 knows which slot to recover.

The old ocfs2 slot map is a very limited.  It has a physical maximum of
254 entries - specifically, it must fit within one disk block.  It only
allows node numbers up to 254, and cannot be extended past INT16_MAX
(32767).  This is a problem in the world of userspace cluster stacks,
where the node numbers are often sparse and can be up to UINT32_MAX.

It also has the structural problem that empty slots are signified by a
magic number.  That number happens to be -1 (0xFFFF).  It makes for code
that isn't as obvious as one would like.

Thus, we introduce a new slot map format, referred to hence as the
"extended slot map".  The extended slot map is allocated as regular file
space, and so is bound by i_size.  The new format adds a "valid" field,
distinct from the node number.  Finally, it has room for extension
should it be needed.

The kernel code is available on the 'new-slot-map' branch of my git
repository.

View:
http://oss.oracle.com/git/?p=jlbec/linux-2.6.git;a=shortlog;h=new-slot-map
Pull:
git pull git://oss.oracle.com/git/jlbec/linux-2.6.git new-slot-map

The tools code is also available via git, in the 'new-slot-map' branch
as well.

View:
http://oss.oracle.com/git/?p=ocfs2-tools.git;a=shortlog;h=new-slot-map
Pull:
git pull git://oss.oracle.com/git/ocfs2-tools.git new-slot-map



