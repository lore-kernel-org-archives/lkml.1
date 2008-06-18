Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYFRM2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYFRM2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbYFRM21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:28:27 -0400
Received: from ozlabs.org ([203.10.76.45]:42448 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471AbYFRM20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:28:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] modules: Take a shortcut for checking if an address is in a module
Date: Wed, 18 Jun 2008 22:27:49 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080610130519.21bc66f3@infradead.org> <20080618095711.GC15255@elte.hu> <1213784671.16944.205.camel@twins>
In-Reply-To: <1213784671.16944.205.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806182227.49821.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 20:24:31 Peter Zijlstra wrote:
> On Wed, 2008-06-18 at 11:57 +0200, Ingo Molnar wrote:
> > * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > > Would it be overkill to simply drop the module addresses in an rbtree
> > > and use that instead of a linear search over all the modules?
> >
> > that's a tempting idea. rbtrees seem to be equally robust to plain lists
> > in my experience, so i'd not find the extra complexity a showstopper, as
> > long as the changes are well-tested. (radix trees on the other hand ...
> > ;-)
>
> Radix trees are unsuited for this application, esp in their current
> implementation.
>
> > Rusty, Peter, Linus, any fundamental objections to Vegard's idea? Being
> > able to take a transparent stack-trace signature for debugging or
> > instrumentation purposes is important and performance does matter there
> > IMO.
>
> A tree makes sense, although if more archs can do the same Arjan did for
> x86 that'd be even better.

Please, just track the max and min module addresses at run time.  That's 
simple, arch-indep and even offers slightly better performance than 
Arjan's :)

Cheers,
Rusty.
