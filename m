Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXC3KB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXC3KB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 06:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXC3KB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 06:01:29 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35199 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXC3KB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 06:01:28 -0400
Date: Fri, 30 Mar 2007 15:38:54 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: jblunck@suse.de
Subject: Heads up on VFS based union mount
Message-ID: <20070330100854.GD16104@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The need for a unified/merged view of two or more filesystems/directories
has been felt for sometime now. Though a few out-of-the-kernel solutions
existed for this, it is only recently that the unionfs(1) solution has gone
into -mm. At the time of merging unionfs into -mm, a few questions were
raised about the appropriateness of having this namespace unification
feature as a separate stackable file system. Encouraged by this comment
from Andrew (http://lkml.org/lkml/2007/1/8/280) and also the interest about
unionfs in recently concluded Linux Storage and Filesystem Workshop(2),
I started looking into Jan Blunck's 2004 diploma thesis work where he had
implemented a VFS based union mount feature. Now Jan and I are working
towards moving this to latest kernel and bringing it to a stage that it
can posted as an RFC. While we are at it, we thought lets give a heads up
on our union mount effort and try to get some early feedbacks/opinions.

While unionfs implements a new filesystem and maintains a set
of VFS objects which stack the real VFS objects under them to get the
unification feature, union mount achieves the same stacking with
minimal (atleast conceptually minimal) changes at the VFS layer.

In union mount approach we maintain this stacking information in the
dentry structure. When a filesytem is union mounted on a mountpoint,
the dentry of the mount root would hold a reference to the mountpoint
dentry as an overlaid dentry and these two dentries together form
a union stack. Any subsequent readdir operation on this union mounted
dentry would work on the overlaid dentry also thereby providing the
merged view of the two filesystems.

Since the stacking information is maintained at the VFS layer, union
mount makes some heavy changes to the VFS lookup code and minor changes
to many VFS routines. Also the whiteout filetype is handled in kernel
and the physical filesytem is expected to support the new whiteout file type.
For copyup, we are right now using a hack of pipe/splice to get the
in-kernel file copy between two layers.

We are planning to post the RFC code pretty soon. More documentation
about the approach would accompany the code.

(1) Unionfs: http://www.filesystems.org/project-unionfs.html
(2) LWN article on LSF07: http://lwn.net/Articles/226351/

Regards,
Bharata.
