Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbXJYQEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbXJYQEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbXJYQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:04:46 -0400
Received: from hera.cwi.nl ([192.16.191.8]:62743 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXJYQEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:04:45 -0400
X-Greylist: delayed 1942 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 12:04:45 EDT
Date: Thu, 25 Oct 2007 17:37:49 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MNT_UNBINDABLE
Message-ID: <20071025153744.GA17681@mette>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some time ago ( http://lkml.org/lkml/2007/6/19/128 )
I wrote about MNT_UNBINDABLE that it felt like a bug
that it is not reset by "mount --make-private".

Today I happened to see mount(8) and Documentation/sharedsubtree.txt
and both document the version obtained by applying the little
patch given in the above (and again below).

So, the present kernel code is not according to specs and must be
regarded as buggy. The patch below, or something similar,
should be applied.

Andries

---
Specification in Documentation/sharedsubtree.txt:
See state diagram: unbindable should become private upon make-private.

Specification in mount(8):
    ...  It's
    also possible to  set  up  uni-directional  propagation  (with  --make-
    slave),  to  make  a  mount  point unavailable for --bind/--rbind (with
    --make-unbindable), and to undo any  of  these  (with  --make-private).

Repeat of old fix-shared-subtrees-make-private.patch
(due to Dirk Gerrits, René Gabriëls, Peter Kooijmans):

--- pnode.old	2007-04-17 12:53:11.000000000 +0200
+++ pnode.c	2007-04-17 13:22:03.000000000 +0200
@@ -83,6 +83,8 @@
 		mnt->mnt_master = NULL;
 		if (type == MS_UNBINDABLE)
 			mnt->mnt_flags |= MNT_UNBINDABLE;
+		else
+			mnt->mnt_flags &= ~MNT_UNBINDABLE;
 	}
 }
 


