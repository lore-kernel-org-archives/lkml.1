Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbXFSMjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbXFSMjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbXFSMjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:39:03 -0400
Received: from hera.cwi.nl ([192.16.191.8]:62347 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755892AbXFSMjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:39:01 -0400
Date: Tue, 19 Jun 2007 14:38:59 +0200 (MEST)
From: <Andries.Brouwer@cwi.nl>
Message-Id: <200706191238.l5JCcxg14300@apps.cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: mount-2.12r-ggk.tar.gz
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The present situation of util-linux and mount is not quite clear to me.
On kernel.org under utils/util-linux nothing has happened for over a year,
and there is also an empty utils/util-linux-ng.

Anyway, Dirk Gerrits, René Gabriël and Peter Kooijmans sent me
a patch to add support for shared subtrees to the mount from
util-linux 2.12r, and I put up the result for ftp at
ftp://ftp.win.tue.nl/pub/linux-local/utils/mount/mount-2.12r-ggk.tar.gz

They remark that it feels like a kernel bug that --make-unbindable
is not reset by --make-private and suggest the patch

--- pnode.old   2007-04-17 12:53:11.000000000 +0200
+++ pnode.c     2007-04-17 13:22:03.000000000 +0200
@@ -83,6 +83,8 @@
                mnt->mnt_master = NULL;
                if (type == MS_UNBINDABLE)
                        mnt->mnt_flags |= MNT_UNBINDABLE;
+               else
+                       mnt->mnt_flags &= ~MNT_UNBINDABLE;
        }
 }

(with white-space damage - my cut&paste).

Without this patch one needs the detour "--make-shared; --make-private"
in order to reset the "unbindable" flag for a private tree.

Andries



[By the way, this shared subtree stuff is a bit messy,
and impossible to support correctly by mount without help
from the kernel. So far the shared/slave/unbindable status
of mounts is not visible in /proc/mounts or /proc/$$/mountstats.
The above mount makes a feeble attempt to record these flags
in /etc/mtab, but will fail in any nontrivial situation.]

