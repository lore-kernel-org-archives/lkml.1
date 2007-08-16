Return-Path: <linux-kernel-owner+w=401wt.eu-S1765264AbXHPWhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765264AbXHPWhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 18:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760546AbXHPWh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 18:37:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:48285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758991AbXHPWhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 18:37:25 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: David Howells <dhowells@redhat.com>
Subject: Re: Adding a security parameter to VFS functions
Date: Fri, 17 Aug 2007 00:36:33 +0200
User-Agent: KMail/1.9.5
Cc: torvalds@osdl.org, viro@ftp.linux.org.uk, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
References: <29015.1187178055@redhat.com>
In-Reply-To: <29015.1187178055@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708170036.34276.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 August 2007 13:40, David Howells wrote:
> 
> Hi Linus, Al,
> 
> Would you object greatly to functions like vfs_mkdir() gaining a security
> parameter?  What I'm thinking of is this:
> 
> 	int vfs_mkdir(struct inode *dir, struct dentry *dentry, int mode,
> 		      struct security *security)
> 
> Where the security context is the state of the context at the time the call
> was issued:
> 
> 	struct security {
> 		uid_t			fsuid;
> 		git_t			fsgid;
> 		struct group_info	*group_info;
> 		void			*security;
> 		struct key		*session_keyring;
> 		struct key		*process_keyring;
> 		struct key		*thread_keyring;
> 
> And perhaps:
> 
> 		struct audit_context	*audit_context;
> 		seccomp_t		seccomp;
> 	};
> 
> This would, for the most part, be a temporary affair, being set up by such
> as sys_mkdir()/sys_mkdirat() from data held in task_struct.

That's additional setup work unless that struct can be embedded in 
task_struct. We would be complicating the common / fast / local case to 
simplify the not-so-common case or cases.

-- Andreas
