Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYBVNHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYBVNHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932715AbYBVNHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:07:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765655AbYBVNHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:07:04 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <55722.57422.qm@web36602.mail.mud.yahoo.com>
References: <55722.57422.qm@web36602.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Trond.Myklebust@netapp.com, chuck.lever@oracle.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 09/37] Security: Allow kernel services to override LSM settings for task actions
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 22 Feb 2008 13:06:29 +0000
Message-ID: <20272.1203685589@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> > +static int smack_task_kernel_act_as(struct task_struct *p,
> > +				    struct task_security *sec, u32 secid)
> > +{
> > +	return -ENOTSUPP;
> > +}
> ...
> > +static int smack_task_create_files_as(struct task_struct *p,
> > +				      struct task_security *sec,
> > +				      struct inode *inode)
> > +{
> > +	return -ENOTSUPP;
> > +}
> 
> Hum. ENOTSUPP is not not very satisfying, is it? I will have to
> think on this a bit.

Sorry, I meant to ping you on this directly.  I'm not sure how to effect these
two functions for Smack.

> Except for the fact that the hooks don't do anything this
> looks fine. I'm not sure that I would want these hooks to
> do anything, it requires additional thought to determine if
> there is a good behavior for them.

Note that you won't be able to use CacheFiles with Smack if either of these
just returns an error.  This may also affect NFSd in the future too.

smack_task_create_files_as() is passed the label that new files created by
CacheFiles should be created with.

For smack_task_kernel_act_as(), it may be sufficient to set CAP_MAC_OVERRIDE in
the task_security struct and leave it as that.  It also may not be sufficient,
as NFSd may end up using this to set the subjective security label supplied by
the NFS client.  I don't know, though, whether Smack is going to be involved in
that passing labels over NFS.

David
