Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268Ab0ARRJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab0ARRJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:09:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0ARRJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:09:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab0ARRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:09:31 -0500
Date: Mon, 18 Jan 2010 19:08:16 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       akpm@linux-foundation.org, andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
Message-ID: <20100118170816.GA22111@redhat.com>
References: <20100118133755.GG30698@redhat.com>
 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
 <20100118141938.GI30698@redhat.com>
 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:05:38PM +0200, Pekka Enberg wrote:
> On Mon, Jan 18, 2010 at 4:19 PM, Gleb Natapov <gleb@redhat.com> wrote:
> > The specific use cases were discussed in the thread following previous
> > version of the patch. I can describe my specific use case in a change log
> > and I can copy what Andrew said about his case, but is it really needed in
> > a commit message itself? It boils down to greater control over when and
> > where application can get major fault. There are applications that need
> > this kind of control. As of use of mlockall(MCL_FUTURE) how can I make
> > sure that all memory allocated behind my application's back (by dynamic
> > linker, libraries, stack) will be locked otherwise?
> 
> Again, why do you want to MCL_FUTURE but then go and use MAP_UNLOCKED?
I need to have all my memory locked except one big (bigger then main
memory) chunk. I either need to rewrite my application and all libraries
to use memory allocator that return locked memory, may be even rewrite
dynamic loader to use this allocator to lock executable code too, or run
mlockall(MCL_FUTURE|MCL_CURRENT) at startup and exempt one allocation
from this rule. Note that I can't allocate it locked and then unlock
since allocation will fail. Actually for me it hangs kernel last I
checked.

> "Greater control" is not an argument for adding a new API that needs
> to be maintained forever, a real world use case is.
> 
If there is real world use case for mlockall() there is real use case for
this too. People seems to be trying to convince me that I don't need
mlockall() without proposing alternatives. The only alternative I see
lock everything from userspace.

> And yes, this stuff needs to be in the changelog. Whether you want to
> spell it out or post an URL to some previous discussion is up to you.
The discussion was here just a couple of days ago. Here is the link
were I describe my use case: http://marc.info/?l=linux-mm&m=126345374125942&w=2
If you think it needs to be spelled out in commit log I'll do it.

--
			Gleb.
