Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbZF3Atx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbZF3Atx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZF3Atq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:49:46 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:39336 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZF3Atp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:49:45 -0400
From: Jeremy Kerr <jk@ozlabs.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] notification tree - fsnotify assumes incorrectly positive parent dentry
Date: Tue, 30 Jun 2009 08:46:29 +0800
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1246305712.754.292.camel@dhcp235-23.rdu.redhat.com> <alpine.LFD.2.01.0906291305030.3605@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906291305030.3605@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906300846.30625.jk@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

> Hmm. It does sound like a reasonable assumption, though. Maybe spufs
> should be fixed to have an inode for all directories?

We have inodes for all directories, it's just the order which we set 
things up. When a new 'spu context' (ie, a directory with a bunch of 
files) is created, we add the parent dentry, populate it with files 
(positive dentries), then instantiate the parent.

There's no specific need to do it in this order, it just makes the code 
a little simpler - we just 'stitch the parent in' once everything else 
has completed successfully, so less stuff to do in the error path.

> A NULL d_inode means that something is a negative dentry, and a
> negative dentry shouldn't have children.

OK. If this is a general invariant, then I'll get a change to spufs 
going to do the setup in the right order.

Cheers,


Jeremy
