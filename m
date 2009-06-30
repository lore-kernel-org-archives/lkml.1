Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZF3BCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZF3BCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbZF3BCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:02:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbZF3BCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:02:38 -0400
Date: Mon, 29 Jun 2009 18:02:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeremy Kerr <jk@ozlabs.org>
cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] notification tree - fsnotify assumes incorrectly
 positive parent dentry
In-Reply-To: <200906300846.30625.jk@ozlabs.org>
Message-ID: <alpine.LFD.2.01.0906291801310.3605@localhost.localdomain>
References: <1246305712.754.292.camel@dhcp235-23.rdu.redhat.com> <alpine.LFD.2.01.0906291305030.3605@localhost.localdomain> <200906300846.30625.jk@ozlabs.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Jun 2009, Jeremy Kerr wrote:
> 
> > Hmm. It does sound like a reasonable assumption, though. Maybe spufs
> > should be fixed to have an inode for all directories?
> 
> We have inodes for all directories, it's just the order which we set 
> things up. When a new 'spu context' (ie, a directory with a bunch of 
> files) is created, we add the parent dentry, populate it with files 
> (positive dentries), then instantiate the parent.
> 
> There's no specific need to do it in this order, it just makes the code 
> a little simpler - we just 'stitch the parent in' once everything else 
> has completed successfully, so less stuff to do in the error path.
> 
> > A NULL d_inode means that something is a negative dentry, and a
> > negative dentry shouldn't have children.
> 
> OK. If this is a general invariant, then I'll get a change to spufs 
> going to do the setup in the right order.

Hmm. I doubt it matters a ton, but if it's easy to change it so that it 
populates the parent inode first, I think that would be a good thing. 
Thanks,

		Linus
