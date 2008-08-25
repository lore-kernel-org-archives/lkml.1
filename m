Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbYHYXac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbYHYXac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 19:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYHYXaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 19:30:23 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:43922 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752306AbYHYXaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 19:30:23 -0400
Date: Mon, 25 Aug 2008 19:30:20 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jeff Dike <jdike@addtoit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: UML build failure in 2.6.27-rc3
Message-ID: <20080825233020.GD9454@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org
References: <E1KWBwC-0002dN-KE@closure.thunk.org> <20080825220406.GC12626@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825220406.GC12626@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 06:04:06PM -0400, Jeff Dike wrote:
> Are you sure you have a consistent tree?  I see no declaration of
> send_sigtrap in ptrace-generic.h.  There is one in asm-x86/ptrace.h
> but it's not at line 51.

Now I see what happened.  I did have a consistent tree, but I was
doing a build via "make ARCH=um O=/usr/projects/linux/uml" --- and I
had previously built a UML tree from another source tree without doing
a "make mrproper", so /usr/projects/linux/uml/include2/asm was a
symlink to another kernel tree's include/asm directory.

It might be nice if kbuild caught the inconsistency, but this was my
bad.

							- Ted
