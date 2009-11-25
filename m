Return-Path: <linux-kernel-owner+w=401wt.eu-S934480AbZKYN2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480AbZKYN2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbZKYN2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbZKYN2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:04 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Extra early pre-pull patch posting
Date: Wed, 25 Nov 2009 14:22:25 +0000
Message-Id: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the larger than usual content of new items in this patch set
I'm posting it a bit earlier than normal so that there is more time
for review.

There are a few bug fixes in this set, but most of the content is
new code relating to xattrs and quotas. The ACL support is cleaned
up and support for caching of ACLs has been added. At the same time
the xattr support has been fixed and clean up too.

There are a series of patches which add support for the XFS-style
quota interface to GFS2. There has always been support for quotas
in GFS2, but the interface was via a userland tool which manipulated
the quota file directly. Due to the way in which the GFS2 quotas
were implemented, they were a better fit for the XFS-style interface
than the dquot interface, so that was the one which we chose to
use. We do not support all features of the XFS quotas though (we
don't have project quotas) and quotas are also turned on and off
only via mount options as we still do not support the set_xstate
function (but we do allow querying of the current quota state via
get_xstate). Aside from that, it does cover most of the XFS feature
set, and everything that is needed to manipulate all supported GFS2
quota types.

The userland tools for generic quota manipulation do not yet
understand how to talk to GFS2's quota interface as they
assume that only XFS uses the XFS-style quota interface. That
is a future project.

In addition to that, the quota netlink notification interface is
made into a generic feature so that GFS2 can use it as well as
dquot based systems.

Other features:
 o Added a barrier/nobarrier option in common with other filesystems
   (N.B. this defaults to on if it isn't specified)
 o A spare field in our common-to-many-objects metadata header is now
   used to write the journal id of the last node to modify that bit
   of metadata. This is ignored by the filesystem, but useful for
   debugging purposes.

I have spotted that one of the patches starts FS2: instead of GFS2:
and I'll try and fix that before the merge. Its a pain as it is part
way down the patch series and I don't think I can fix it without
rebasing the tree.

Let me know if you spot anything else thats wrong,

Steve.


