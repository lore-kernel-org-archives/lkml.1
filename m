Return-Path: <linux-kernel-owner+w=401wt.eu-S1765000AbZFQJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765000AbZFQJBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZFQJBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 05:01:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43569 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754763AbZFQJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 05:01:07 -0400
Date: Wed, 17 Jun 2009 10:00:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Subject: Re: [PATCH 00/17] [RFC] AFS: Implement OpenAFS pioctls(version)s
Message-ID: <20090617100057.2c505f1c@lxorguk.ukuu.org.uk>
In-Reply-To: <11650.1245198358@redhat.com>
References: <20090617001157.065ee652@lxorguk.ukuu.org.uk>
	<20090616203845.4526.60013.stgit@warthog.procyon.org.uk>
	<10437.1245193192@redhat.com>
	<11650.1245198358@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Can you not put pioctl() into a C library linked with the openafs utilities
> > that generates more sensible interface calls?  I mean you have to produce
> > the pioctl() syscall wrapper anyway so why not make "pioctl" a user space
> > compat library?
> 
> pioctl() is almost implementable with a combination of (l)setxattr,
> (l)getxattr, set_key, keyctl_read, and if all else fails, open + ioctl or
> open(O_NOFOLLOW) + ioctl, but not quite completely.  There are things you can't
> open, even with O_NOFOLLOW.  And doing state-retaining setxattr/getxattr pairs
> is even more nasty than pioctl (IIRC, that's something Christoph suggested a
> while back).
> 
> Besides, I want a set of utilities that I can use in conjunction with both kAFS
> and OpenAFS without having to recompile.

"I want" isn't a good policy for the introduction of ugly as sin long
term interfaces into the kernel. Besides which you argument doesn't
actually make sense anyway.

If you have to put a pioctl() wrapper in a library then you can compile
both sets of tools with your wrapper library and the library can do the
relevant gunge to decide how to make the kernel calls and which ones to
make.

The pioctl() interface is crap, keep it in user space wrappers and put
actual proper structured interfaces into the kernel.
