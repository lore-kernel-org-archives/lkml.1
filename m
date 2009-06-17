Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZFQHz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZFQHz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 03:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbZFQHzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 03:55:13 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:49172 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZFQHzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 03:55:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Wed, 17 Jun 2009 01:55:02 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
In-reply-to: <11650.1245198358@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-afs@lists.infradead.org
Message-id: <20090617075502.GB13073@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk>
 <20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
 <10437.1245193192@redhat.com> <11650.1245198358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 17, 2009  01:25 +0100, David Howells wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > But if we add an ABI we end up stuck with it and this one is really
> > really rather ugly.
> 
> Somewhat less ugly than ioctl, for instance, but you're not entirely wrong.
> There is no good way of doing this.
> 
> > Can you not put pioctl() into a C library linked with the openafs utilities
> > that generates more sensible interface calls?  I mean you have to produce
> > the pioctl() syscall wrapper anyway so why not make "pioctl" a user space
> > compat library?
> 
> pioctl() is almost implementable with a combination of (l)setxattr,
> (l)getxattr, set_key, keyctl_read, and if all else fails, open + ioctl or
> open(O_NOFOLLOW) + ioctl, but not quite completely.  There are things you
> can't open, even with O_NOFOLLOW.  And doing state-retaining setxattr/
> getxattr pairs is even more nasty than pioctl (IIRC, that's something
> Christoph suggested a while back).

What about opening the mountpoint (which HAS to be available) and then
calling an ioctl() on that?  At least the mess would be contained within
AFS instead of requiring several new syscalls.

> Besides, I want a set of utilities that I can use in conjunction with both
> kAFS and OpenAFS without having to recompile.

That doesn't mean it isn't possible to have the same user-space utilities,
just that the pioctl() wrapper will need to multiplex its behaviour depending
on whether it is working with kAFS or OpenAFS.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

