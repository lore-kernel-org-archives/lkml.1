Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbXHITfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbXHITfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbXHITex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:34:53 -0400
Received: from namei.org ([69.55.235.186]:43325 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751029AbXHITew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:34:52 -0400
Date: Thu, 9 Aug 2007 12:34:13 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: Casey Schaufler <casey@schaufler-ca.com>, torvalds@osdl.org, akpm@osdl.org,
       steved@redhat.com, trond.myklebust@fys.uio.no,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be
 obtained [try #2]
In-Reply-To: <22259.1186686459@redhat.com>
Message-ID: <Pine.LNX.4.64.0708091223330.19611@us.intercode.com.au>
References: <Pine.LNX.4.64.0708091143440.19611@us.intercode.com.au>
 <162335.27499.qm@web36605.mail.mud.yahoo.com> <22259.1186686459@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, David Howells wrote:

> James Morris <jmorris@namei.org> wrote:
> 
> > David, I've looked at the code and can't see that you need to access the 
> > label itself outside the LSM.  Could you instead simply pass the inode 
> > pointer around?
> 
> It's not quite that simple.  I need to impose *two* security labels in
> cachefiles_begin_secure() when I'm about to act on behalf of a process that's
> tried to access a netfs file:

Ah ok, we had a similar problem with NFS mount options.

While I'm concerned about encoding SELinux-optimized secid labels into 
general kernel structures, moving to more generalized pointers introduces 
lifecycle maintenance issues and complexity which is not needed in the 
mainline kernel.  i.e. it'll be unused infrastructure maintained by 
upstream, and used only by out-of-tree modules.

So, given that the kernel has no stable API, I suggest accepting the u32 
secid as you propose, and if someone wants to merge a module which also 
uses these hooks, but is entirely unable to use u32 labels, then they can 
also justify making the interface more generalized and provide the code 
for it.



- James 
-- 
James Morris
<jmorris@namei.org>
