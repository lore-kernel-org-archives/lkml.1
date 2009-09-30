Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZI3KVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZI3KVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 06:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZI3KVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 06:21:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZI3KVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:21:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909290909280.6996@localhost.localdomain> <alpine.LFD.2.01.0909280743310.3349@localhost.localdomain> <20090928135332.4300.56046.stgit@warthog.procyon.org.uk> <20090928151628.62955233@lxorguk.ukuu.org.uk> <395.1254239745@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove pty_ops_bsd and pty_bsd_ioctl() as they're not used
Date: Wed, 30 Sep 2009 11:20:00 +0100
Message-ID: <29895.1254306000@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I do wonder whether the right thing to do would not be to simple remove 
> the whole pty_ops_bsd code entirely. Or maybe mode the trivial TIOCSPTLCK 
> into the generic tty ioctl handling, and just make it test for 
> "driver->subtype == PTY_TYPE_MASTER" - and at least get rid of this subtle 
> thing that was broken for over a year without anybody noticing..

Also, does it matter if someone issues TIOCGPTN on a legacy pty master?  There
is a number in tty->index that can be returned.  If it can, then
pty_bsd_ioctl() can be merged with pty_unix98_ioctl(), and possibly both
ioctls can be given to the generic tty ioctl handling with the condition that
driver->subtype == PTY_TYPE_MASTER.

David
