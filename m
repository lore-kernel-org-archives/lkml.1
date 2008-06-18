Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539AbYFRKYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbYFRKYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYFRKYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:24:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:60353 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752214AbYFRKY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:24:29 -0400
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is
	in a module
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080618095711.GC15255@elte.hu>
References: <20080610130519.21bc66f3@infradead.org>
	 <200806112112.08623.rusty@rustcorp.com.au>
	 <20080611081847.0b22079c@infradead.org>
	 <19f34abd0806111154q77739a2m8dcff24e2f9a3922@mail.gmail.com>
	 <20080618095711.GC15255@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 12:24:31 +0200
Message-Id: <1213784671.16944.205.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-18 at 11:57 +0200, Ingo Molnar wrote:
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
> > >  > > Various pieces of the kernel (lockdep, latencytop, etc) tend to 
> > >  > > store backtraces, sometimes at a relatively high frequency. In 
> > >  > > itself this isn't a big performance deal (after all you're 
> > >  > > using diagnostics features), but there have been some 
> > >  > > complaints from people who have over 100 modules loaded that 
> > >  > > this is a tad too slow.
> > 
> > Would it be overkill to simply drop the module addresses in an rbtree 
> > and use that instead of a linear search over all the modules?
> > 
> > It would probably take a fair number of lines in C, and with a little 
> > memory overhead, but the speed-up should be great. Should I give it a 
> > try? (It would be arch-independent too.)
> 
> that's a tempting idea. rbtrees seem to be equally robust to plain lists 
> in my experience, so i'd not find the extra complexity a showstopper, as 
> long as the changes are well-tested. (radix trees on the other hand ... 
> ;-)

Radix trees are unsuited for this application, esp in their current
implementation.

> Rusty, Peter, Linus, any fundamental objections to Vegard's idea? Being 
> able to take a transparent stack-trace signature for debugging or 
> instrumentation purposes is important and performance does matter there 
> IMO.

A tree makes sense, although if more archs can do the same Arjan did for
x86 that'd be even better.

