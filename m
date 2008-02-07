Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYBGK6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYBGK6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYBGK6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:58:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbYBGK6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:58:07 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <479901A8.3000706@oracle.com>
References: <479901A8.3000706@oracle.com> <20080123172038.11107.86025.stgit@warthog.procyon.org.uk> <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
To: chuck.lever@oracle.com
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 07 Feb 2008 10:57:49 +0000
Message-ID: <28135.1202381869@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Lever <chuck.lever@oracle.com> wrote:

> > @@ -95,12 +100,25 @@ struct nfs_server {
> >  	unsigned int		acdirmin;
> >  	unsigned int		acdirmax;
> >  	unsigned int		namelen;
> > +	unsigned int		options;	/* extra options enabled by mount */
> > +#define NFS_OPTION_FSCACHE	0x00000001	/* - local caching enabled */
> 
> Why did you choose to create a new field for this rather than setting up a new
> NFS_MNT flag?  The new in-kernel NFS mount option parser uses the NFS_MNT
> flags too.

There aren't any NFS_MNT flags, so I presume you mean NFS_MOUNT flags.  As I
understood Trond, it's not permitted to add new such flags except in really
special circumstances as these are part of the mount syscall interface.  I
took this to mean that I should record the option elsewhere than in
server->flags.

David
