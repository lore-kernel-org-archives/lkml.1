Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZDXMX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZDXMX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZDXMXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 08:23:48 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:58353 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbZDXMXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 08:23:45 -0400
Date: Fri, 24 Apr 2009 12:57:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Oleg Nesterov <oleg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Malicki <jmalicki@metacarta.com>, Michael Itz <mitz@metacarta.com>,
       Kenneth Baker <bakerk@metacarta.com>,
       Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: [PATCH 3/2] check_unsafe_exec: rcu_read_unlock
In-Reply-To: <20090423233157.GA22981@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0904241255580.20196@blonde.anvils>
References: <20090401023849.GW28946@ZenIV.linux.org.uk>
 <20090401030339.GX28946@ZenIV.linux.org.uk> <20090406153127.GA21220@redhat.com>
 <Pine.LNX.4.64.0904191710320.9099@blonde.anvils> <20090421161006.GC5402@redhat.com>
 <alpine.LFD.2.00.0904210924270.2199@localhost.localdomain>
 <20090421171530.GA12014@redhat.com> <alpine.LFD.2.00.0904211032191.2199@localhost.localdomain>
 <Pine.LNX.4.64.0904212031120.10256@blonde.anvils> <20090423230156.GA31302@redhat.com>
 <20090423233157.GA22981@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in previous commit: second rcu_read_lock should be rcu_read_unlock.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.30-rc3-next-20090424/fs/exec.c	2009-04-24 12:23:43.000000000 +0100
+++ linux/fs/exec.c	2009-04-24 12:26:10.000000000 +0100
@@ -1043,7 +1043,7 @@ int check_unsafe_exec(struct linux_binpr
 		if (t->fs == p->fs)
 			n_fs++;
 	}
-	rcu_read_lock();
+	rcu_read_unlock();
 
 	if (p->fs->users > n_fs) {
 		bprm->unsafe |= LSM_UNSAFE_SHARE;
