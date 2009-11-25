Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbZKYImD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbZKYImD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZKYImA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:42:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:51557 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123AbZKYImA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:42:00 -0500
Date: Wed, 25 Nov 2009 19:41:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>
Subject: Re: [RFC][PATCH] security/selinux: Simplify proc inode to security
 label mapping.
In-Reply-To: <m11vjtrpfk.fsf@fess.ebiederm.org>
Message-ID: <alpine.LRH.2.00.0911251939450.9198@tundra.namei.org>
References: <m11vjtrpfk.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009, Eric W. Biederman wrote:

> 
> Currently selinux has incestuous knowledge of the implementation details
> of procfs and sysctl that it uses to get a pathname from an inode. As it
> happens the point we care is in the security_d_instantiate lsm hook so
> we have a valid dentry that we can use to get the entire pathname on
> the proc filesystem.  With the recent change to sys_sysctl to go through
> proc/sys all proc and sysctl accesses go through the vfs, which
> means we no longer need a sysctl special case.
> 
> So get the path for the dentry, remove the incestuous knowledge
> and simplify the code.
> 
> caveat: Because the dentry may not yet be hashed I think dentry_path will
>         append (deleted) and thus is not the right function to call.

This seems to break labeling.  Prior to this patch, I see:


# ls -lZ /proc/1/net/rpc/nfsd.fh
-rw-------. root root system_u:object_r:sysctl_rpc_t:s0 channel

with the patch:

# ls -lZ /proc/1/net/rpc/nfsd.fh
-rw-------. root root system_u:object_r:proc_t:s0      channel


-- 
James Morris
<jmorris@namei.org>
