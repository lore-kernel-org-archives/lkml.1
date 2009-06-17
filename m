Return-Path: <linux-kernel-owner+w=401wt.eu-S932401AbZFQReh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbZFQReh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbZFQReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:34:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759040AbZFQReE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:34:04 -0400
Date: Wed, 17 Jun 2009 10:33:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andreas Dilger <adilger@sun.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-Reply-To: <28023.1245259479@redhat.com>
Message-ID: <alpine.LFD.2.01.0906171027470.16802@localhost.localdomain>
References: <alpine.LFD.2.01.0906170901480.16802@localhost.localdomain> <20090617001157.065ee652@lxorguk.ukuu.org.uk> <20090616203845.4526.60013.stgit@warthog.procyon.org.uk> <10437.1245193192@redhat.com> <11650.1245198358@redhat.com>
 <20090617075502.GB13073@webber.adilger.int> <28023.1245259479@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, David Howells wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > What about opening the mountpoint (which HAS to be available) and then
> > > calling an ioctl() on that?
> > 
> > It's very hard to "open the mountpoint" in user space. How would you even 
> > do it? Remember: we're not living in the 1980's any more, and disco is 
> > dead. ABBA may have made a comeback, but static mountpoints are long gone, 
> > and won't be coming back.
> 
> I think what Andreas means is open the directory at the root of the mounted
> tree, i.e. "/afs" for AFS, and then do an ioctl() on that that emulates
> pioctl().

I agree that that is what he means.

What _I_ mean is that THIS IS IMPOSSIBLE TO DO FROM USER SPACE!

Try it. Not doable. User space simply doesn't know enough, and has 
fundamental races with mount/umount.

Sure, you can try to do it by trying to parse the pathname and looking in 
/etc/mtab or /proc/mounts. And I guarantee that the end result will be a 
buggy pile of sh*t.

End result: you do need a new system call. 

I just don't think "pioctl()" is a good one. You'd be better off with some 
modification of open and then use ioctl.

			Linus
