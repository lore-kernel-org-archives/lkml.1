Return-Path: <linux-kernel-owner+w=401wt.eu-S1765824AbXHIUet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765824AbXHIUet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbXHIUeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:34:01 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:46230 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762426AbXHIUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:33:58 -0400
X-YMail-OSG: e0QUJ6AVM1mwIJIIROJF.M9WLPn9O3XIBTq_LZVCW19DbSrRAzapEhQgeUCcz4XFH_Qho2sQpg--
X-RocketYMMF: rancidfat
Date: Thu, 9 Aug 2007 13:33:57 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be obtained [try #2]
To: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708091223330.19611@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <503721.44439.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> On Thu, 9 Aug 2007, David Howells wrote:
> 
> > James Morris <jmorris@namei.org> wrote:
> > 
> > > David, I've looked at the code and can't see that you need to access the 
> > > label itself outside the LSM.  Could you instead simply pass the inode 
> > > pointer around?
> > 
> > It's not quite that simple.  I need to impose *two* security labels in
> > cachefiles_begin_secure() when I'm about to act on behalf of a process
> that's
> > tried to access a netfs file:
> 
> Ah ok, we had a similar problem with NFS mount options.
> 
> While I'm concerned about encoding SELinux-optimized secid labels into 
> general kernel structures, moving to more generalized pointers introduces 
> lifecycle maintenance issues and complexity which is not needed in the 
> mainline kernel.  i.e. it'll be unused infrastructure maintained by 
> upstream, and used only by out-of-tree modules.
> 
> So, given that the kernel has no stable API, I suggest accepting the u32 
> secid as you propose, and if someone wants to merge a module which also 
> uses these hooks, but is entirely unable to use u32 labels, then they can 
> also justify making the interface more generalized and provide the code 
> for it.

Grumble. Yet another thing to undo in the near future. I still
hope to suggest what I would consider a viable alternative "soon".


Casey Schaufler
casey@schaufler-ca.com
