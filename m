Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbZFQSjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbZFQSjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbZFQSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:38:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34527 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760697AbZFQSix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:53 -0400
Date: Wed, 17 Jun 2009 19:37:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Dilger <adilger@sun.com>, David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Message-ID: <20090617183745.GI8633@ZenIV.linux.org.uk>
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com> <20090617075502.GB13073@webber.adilger.int> <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 09:09:47AM -0700, Linus Torvalds wrote:
> We've traditionally had that magic "open with flag=3" to do a magic open 
> of device files without waiting, and we have O_NOFOLLOW to open symlinks 
> without following them (sadly, it just errors out, rather than opening the 
> symlink, but that's another detail). 
> 
> So I think it should be solvable some way, but not by trying to find the 
> mount point.

O_NOFOLLOW *will* open their mountpoints just fine, without triggering
automount.  Of course, if something's already mounted there, it will
get you the covering object.  Which is a feature, as far as I'm concerned,
since "I've overmounted that to have it unreachable" shouldn't be breakable
regardless of the syscall we are using - be it open() or pioctl().

FWIW, count me strongly opposed to that shit; it's too damn ugly to live,
has interesting security implications and we'll get stuck with it forever.
And we *really* don't need another multiplexor from hell, without anything
resembling well-defined semantics.
