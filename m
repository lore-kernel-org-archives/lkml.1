Return-Path: <linux-kernel-owner+w=401wt.eu-S1422966AbXCGRe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422966AbXCGRe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:34:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422768AbXCGRQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:37 -0500
Received: from raven.upol.cz ([158.194.120.4]:42945 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422860AbXCGRQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:22 -0500
Date: Wed, 7 Mar 2007 18:24:49 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       akpm@linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, johannes@sipsolutions.net
Subject: Re: ALIGN via ilog2 without gccisms (Re: [PATCH] Fix get_order())
Message-ID: <20070307172449.GR16509@flower.upol.cz>
References: <Pine.LNX.4.64.0703061913080.5963@woody.linux-foundation.org> <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com> <8543.1173267786@redhat.com> <E1HOybN-00031m-6M@flower> <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703070836220.5963@woody.linux-foundation.org>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 08:38:27AM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 7 Mar 2007, Oleg Verych wrote:
> >
> > Probably it can be used to get rid of gccisms and "type fluff" due to
> > bitwise arithmetics in ALIGN?
> 
> Hell no.
> 
> The typeof is there to make sure we have the right type, and it's simple.
> 
> The current ALIGN() macro is efficient as hell (generating just a simple 
> mask+add). Turning it into some kind of horrible thing that uses ilog2() 
> would be a total mistake.

GCC's assembler version of this macro is optimized as needed.

But i wanted to address Al's statement about using typeof():

,-*- [ Message-ID: <20061127044138.GA3078@ftp.linux.org.uk> ]
|IOW, gcc allows type to leak out of scope it's been defined in (and
|typeof adds even more fun to the picture).  It not only goes against
|a _lot_ in C, it's actually not thought through by gcc folks.  Just
|try to mix that with variable-length arrays and watch it blow up
|in interesting ways...
`-*-

As for me, this is example of assembler's need, that very hard to
implement in C. Also, i doubt, C's shift doing any "type fluff" on its
only argument.

> Also, your ALIGN() macro was broken. That's not how ALIGN() is supposed to 
> work.

Yes, maybe so.
____

