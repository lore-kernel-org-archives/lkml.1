Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0CBIBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:01:30 -0500
Received: from tundra.namei.org ([65.99.196.166]:56054 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab0CBIB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:01:28 -0500
Date: Tue, 2 Mar 2010 19:01:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: linux-fsdevel@vger.kernel.org
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
Subject: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted'
 xattrs
Message-ID: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that there are differences in the behavior of listxattr(2) for 
xattrs in the trusted namespace.

Some filesystems, such as ext[234], require CAP_SYS_ADMIN for this, i.e. 
trusted xattr names are hidden from unprivileged users.

I audited the kernel for users of the trusted xattr namespace, and found 
the following filesystems not checking for CAP_SYS_ADMIN:

  - jffs2
  - ocfs2
  - btrfs
  - xfs

I've created patches for jffs2 (tested) and ocfs2 (not tested) to add the 
check -- see following emails. btrfs and xfs have custom listxattr 
operations and will need a bit more work to fix.

I'm not sure what the initial intention was for the behavior, although 
given that several major filesystems are have been fielded with the 
CAP_SYS_ADMIN check, it seems most prudent to make this the standard 
behavior for all filesystems, in case any users are depending on it.

Thoughts?


- James
-- 
James Morris
<jmorris@namei.org>
