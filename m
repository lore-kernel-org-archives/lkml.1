Return-Path: <linux-kernel-owner+w=401wt.eu-S1760990AbZDQRlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990AbZDQRlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758066AbZDQRli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:41:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39208 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792AbZDQRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:41:38 -0400
Date: Fri, 17 Apr 2009 18:41:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Alessio Igor Bogani <abogani@texware.it>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090417174134.GK26366@ZenIV.linux.org.uk>
References: <1239892078-6039-1-git-send-email-abogani@texware.it> <20090416160645.GB17804@elte.hu> <20090416235649.GF26366@ZenIV.linux.org.uk> <20090417000142.GF21405@elte.hu> <20090417001345.GH26366@ZenIV.linux.org.uk> <20090417002744.GB29630@elte.hu> <20090417003805.GI26366@ZenIV.linux.org.uk> <20090417165643.GL8253@elte.hu> <1239987885.23397.4817.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239987885.23397.4817.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 07:04:45PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-04-17 at 18:56 +0200, Ingo Molnar wrote:
> 
> > Stupid question regarding c): wouldnt such data structures go via 
> > the VFS - which you said was free of BKL constraints? Or are there 
> > interconnected private data structures between certain types of 
> > closely related filesystems that the VFS does not know about? (and 
> > hence might have BKL assumptions)
> 
> The VFS is stuffed with ->private like pointers for filesystems to flesh
> out, and I could well imagine some implicit serialization between the
> various (4?) VFS hooks that are currently still under BKL.

Explicit one, TYVM...  Anyway, any fs that dares to use private data of
objects from another filesystem deserves everything it gets; I'm not
aware of any that would do that and I have no sympathy whatsoever to
any that would try.

That's not what I'd been talking about, though; what we want to watch out
for is sharing of data structures by some (or all) fs instances of given
type.  I.e. internals of particular fs driver, not cross-driver problems.
