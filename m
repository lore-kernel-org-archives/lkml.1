Return-Path: <linux-kernel-owner+w=401wt.eu-S1754345Ab0AIB6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab0AIB6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 20:58:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690Ab0AIB6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 20:58:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab0AIB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 20:58:13 -0500
Date: Fri, 8 Jan 2010 17:57:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Fix up the NFS mmap code
In-Reply-To: <20100109013825.GD30528@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1001081750080.7821@localhost.localdomain>
References: <1262913974.2659.101.camel@localhost> <20100109005624.7473.33215.stgit@localhost.localdomain> <alpine.LFD.2.00.1001081709470.7821@localhost.localdomain> <20100109013825.GD30528@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Jan 2010, Al Viro wrote:
> 
> readdir() is certainly a red herring.

That's the one that lockdep reports, though. I still don't see why. Afaik, 
the only place where NFS gets an inode is nfs_fhget(), and that seems to 
do things correctly.

> write(), OTOH, is quite real. And there we do i_mutex followed by 
> pagefaults.

Ho humm.. 

> Could we please get a sane expalanation of the reasons why nfs mmap
> wants i_mutex in the first place?  Before we add yet another hook
> from hell and complicate already overcomplicated area...

Yeah, agreed.

		Linus
