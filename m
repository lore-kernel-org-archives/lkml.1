Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbZFQSwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbZFQSwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbZFQSwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:52:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37538 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbZFQSwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:52:37 -0400
Date: Wed, 17 Jun 2009 19:52:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Dilger <adilger@sun.com>, David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Message-ID: <20090617185219.GJ8633@ZenIV.linux.org.uk>
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617183745.GI8633@ZenIV.linux.org.uk> <alpine.LFD.2.01.0906171142580.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906171142580.16802@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 11:44:18AM -0700, Linus Torvalds wrote:
> > O_NOFOLLOW *will* open their mountpoints just fine, without triggering
> > automount.
> 
> That's not the problem with O_NOFOLLOW.
> 
> The problem is that if you want to actually open the symlink itself (say, 
> you do some filesystem cleanup operation on it, like saying "drop the 
> caches of this file"), you can't do it. O_NOFOLLOW won't open the symlink, 
> it will just refuse to follow it, and return an error.

... so we need a syscall that would do that "drop the caches" operation.
_After_ having decided that it's really needed for symlinks.  With decision
made on per-operation basis.  Sure, it will be painful for people proposing
such operations, which is just fine by me - barriers to adding new primitives
shouldn't be low.
