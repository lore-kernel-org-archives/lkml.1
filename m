Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0CCNQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:16:52 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:44659 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0CCNQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:16:50 -0500
Subject: Re: [RFC][PATCH 0/2] Correct behavior for listxattr and 'trusted'
 xattrs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       Alex Elder <aelder@sgi.com>, Chris Mason <chris.mason@oracle.com>,
       a.gruenbacher@computer.org
In-Reply-To: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
References: <alpine.LRH.2.00.1003021845310.1594@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 03 Mar 2010 08:02:58 -0500
Message-Id: <1267621378.3436.15.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-02 at 19:01 +1100, James Morris wrote:
> I noticed that there are differences in the behavior of listxattr(2) for 
> xattrs in the trusted namespace.
> 
> Some filesystems, such as ext[234], require CAP_SYS_ADMIN for this, i.e. 
> trusted xattr names are hidden from unprivileged users.
> 
> I audited the kernel for users of the trusted xattr namespace, and found 
> the following filesystems not checking for CAP_SYS_ADMIN:
> 
>   - jffs2
>   - ocfs2
>   - btrfs
>   - xfs
> 
> I've created patches for jffs2 (tested) and ocfs2 (not tested) to add the 
> check -- see following emails. btrfs and xfs have custom listxattr 
> operations and will need a bit more work to fix.
> 
> I'm not sure what the initial intention was for the behavior, although 
> given that several major filesystems are have been fielded with the 
> CAP_SYS_ADMIN check, it seems most prudent to make this the standard 
> behavior for all filesystems, in case any users are depending on it.
> 
> Thoughts?

Should it be using has_capability_noaudit() rather than capable() so
that merely calling listxattr() on a file that happens to have trusted
xattrs does not set PF_SUPERPRIV on the task and does not trigger an
audit message?

-- 
Stephen Smalley
National Security Agency

