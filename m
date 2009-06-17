Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZFQSpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZFQSpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbZFQSpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:45:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbZFQSpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:45:19 -0400
Date: Wed, 17 Jun 2009 11:44:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Andreas Dilger <adilger@sun.com>, David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-Reply-To: <20090617183745.GI8633@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.01.0906171142580.16802@localhost.localdomain>
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain>
 <20090617183745.GI8633@ZenIV.linux.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Al Viro wrote:

> On Wed, Jun 17, 2009 at 09:09:47AM -0700, Linus Torvalds wrote:
> > We've traditionally had that magic "open with flag=3" to do a magic open 
> > of device files without waiting, and we have O_NOFOLLOW to open symlinks 
> > without following them (sadly, it just errors out, rather than opening the 
> > symlink, but that's another detail). 
> > 
> > So I think it should be solvable some way, but not by trying to find the 
> > mount point.
> 
> O_NOFOLLOW *will* open their mountpoints just fine, without triggering
> automount.

That's not the problem with O_NOFOLLOW.

The problem is that if you want to actually open the symlink itself (say, 
you do some filesystem cleanup operation on it, like saying "drop the 
caches of this file"), you can't do it. O_NOFOLLOW won't open the symlink, 
it will just refuse to follow it, and return an error.

			Linus
