Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYHNCnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYHNCnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 22:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYHNCnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 22:43:23 -0400
Received: from tundra.namei.org ([65.99.196.166]:42717 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYHNCnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 22:43:23 -0400
Date: Thu, 14 Aug 2008 12:42:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: lachlan@sgi.com, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Resolved XFS conflict in next-creds
Message-ID: <alpine.LRH.1.10.0808141239200.27768@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I resolved the following conflict with Linus' tree in:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds


commit 4030dcef54030fdb4ad6ff3813ac031d7afbdf35
Merge: 1e058f1... 8d0968a...
Author: James Morris <jmorris@namei.org>
Date:   Thu Aug 14 10:43:47 2008 +1000

    Merge branch 'master' into next-creds
    
    Conflicts:
    
        fs/xfs/xfs_acl.c
    
    Signed-off-by: James Morris <jmorris@namei.org>

diff --cc fs/xfs/xfs_acl.c
index f94e5a8,b2f639a..91d6933
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@@ -372,7 -366,7 +366,7 @@@ xfs_acl_allow_set
                return ENOTDIR;
        if (vp->i_sb->s_flags & MS_RDONLY)
                return EROFS;
-       if (xfs_vtoi(vp)->i_d.di_uid != current_fsuid() && !capable(CAP_FOWNER))
 -      if (XFS_I(vp)->i_d.di_uid != current->fsuid && !capable(CAP_FOWNER))
++      if (XFS_I(vp)->i_d.di_uid != current_fsuid() && !capable(CAP_FOWNER))
                return EPERM;
        return 0;
  }



-- 
James Morris
<jmorris@namei.org>
