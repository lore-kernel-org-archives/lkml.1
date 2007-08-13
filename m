Return-Path: <linux-kernel-owner+w=401wt.eu-S944583AbXHMQ7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944583AbXHMQ7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031213AbXHMQch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:32:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S969113AbXHMQce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:32:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <26859.95417.qm@web36612.mail.mud.yahoo.com>
References: <26859.95417.qm@web36612.mail.mud.yahoo.com>
To: casey@schaufler-ca.com
Cc: dhowells@redhat.com, Stephen Smalley <sds@tycho.nsa.gov>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/16] Permit filesystem local caching [try #3]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 13 Aug 2007 17:31:43 +0100
Message-ID: <13221.1187022703@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:

> >   (1) int security_get_context(void **_context);
> > 
> > 	This allocates and gives the caller a blob that describes the current
> > 	context of all the LSM module states attached to the current task and
> > 	stores a pointer to it in *_context.
> 
> Is this intended to be anything more than a copy of current->security?

It has to be sufficient to fully effect security_push().

> I assume that you're talking about the LSM specific data changing,
> not the LSM itself.

Yes.

> If you change the task->security information you are definitly going
> to change what other tasks can do to the calling task.

I dealt with that in my current act-as patch.  Under SELinux a task has two
primary labels.  One with which it is labelled and is used to govern effects
upon it, and one that is used to act upon things and follows changes to the
former.

> >   (5) int security_xfrm_to_kernel_context(void *from, void **_to);
> 
> Woof. What are you transforming from? 

In CacheFiles case, the cachefilesd daemon's security label into the label the
cache driver acts as on behalf of other processes.

> That's the really nice thing about cans of worms.
> They come in six-packs.

Yeah...

David
