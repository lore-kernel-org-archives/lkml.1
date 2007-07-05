Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXGES6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXGES6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 14:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759896AbXGES60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 14:58:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36708 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759838AbXGES6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 14:58:25 -0400
Subject: Re: [RFC] bloody mess with __attribute__() syntax
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070705164334.GM21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk>
	 <468D1003.1050901@freedesktop.org>
	 <20070705164334.GM21478@ftp.linux.org.uk>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 11:50:56 -0700
Message-Id: <1183661456.2604.43.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 17:43 +0100, Al Viro wrote:
> On Thu, Jul 05, 2007 at 08:36:35AM -0700, Josh Triplett wrote:
> > Wow.  Insane.  So these all declare the same type:
> > __attribute__((foo)) T *v;
> > T __attribute__((foo)) *v;
> > T *__attribute__((foo)) v;
> > ?  Specifically, they point to a foo-T, for convenient shooting?
> 
> They all give you foo-pointer-to-T.  
> 	T (__attribute__((foo)) *v);
> would give pointer-to-foo-T.

Doesn't that do exactly what we want, then?  If we say
T __attribute__((noderef)) *v;
, we want a noderef-pointer-to-T, not a pointer-to-noderef-T.  noderef
should modify a pointer.

> > context also represents a qualifier; the position of the qualifier should
> > determine things like whether you want to enforce the context when you access
> > a pointer or dereference a pointer.
> 
> Since __context__ is (sparse-only) keyword, we are not constrained by
> anything anyway.

No, I mean __attribute__((context(...))), which means something
different.  __context__() works as a statement statement changing the
context.  __attribute__((context(...))) works as an attribute modifying
a type to say that it requires a given context, and that
accessing/calling it changes the context.  Somewhat of an odd
distinction, but sparse currently works that way.

> > > Frankly, I would rather add a new primitive (__qualifier__) mirroring the
> > > __attribute__, but acting like real qualifiers do.  And switched the
> > > noderef et.al. to it.
> > 
> > Something like that sounds vaguely reasonable.  It should allow the same set
> > of attributes, and just change what they apply to.  To use your example,
> > T __qualifier__((foo)) *v;
> > and
> > T (__attribute__((foo)) *v);
> > would mean the same thing.
> 
> Yup, except that it would not accept storage-class-like attributes (e.g.
> always_inline).

So, to clarify what you mean by storage-class-like: __qualifier__ would
accept all attributes that modify a *type* rather than a *declaration*.

> And yes, __qualifier__((context(...))) probably might
> be a replacement for __context__, to reduce the number of primitives.

No, see above.  __context__ works as a statement, not as a way to modify
a type.

That said, "calling this function requires this context or changes the
context" and "accessing this variable requires this context or changes
the context" may represent different types of attributes.  I don't know.

- Josh Triplett


