Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbYDCBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbYDCBeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 21:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbYDCBeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 21:34:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46095 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327AbYDCBeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 21:34:23 -0400
Date: Thu, 3 Apr 2008 02:34:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, josh@freedesktop.org
Subject: Re: [PATCH 7/7] asm-generic: suppress sparse warning in ioctl.h
Message-ID: <20080403013420.GV9785@ZenIV.linux.org.uk>
References: <1207182818.5740.26.camel@brick> <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804021752040.14670@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 05:57:54PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 2 Apr 2008, Harvey Harrison wrote:
> >
> > 1 ? 0 : x
> > 
> > is not valid in contexts where C requires integer constant expressions.
> > Index in static array initializer is one of those.
> 
> So I don't much like this one, because (a) we could just make sparse 
> accept it and (b) gcc _does_ accept it and gives us nicer error messages. 

Umm...  How far do you want sparse to go?  You _really_ don't want
bug-for-bug compatibility with gcc - it's far too weird (and that's
even before going into the effects of optimization flags).

BTW, what happened with sparse.git?  The last changeset in there (in
/pub/scm/devel/sparse/sparse.git/ on g.k.o) is
commit a02aeb329d5a8f9047c0b75b7e7f64ee2db3ffcf
Author: Josh Triplett <josh@freedesktop.org>
Date:   Tue Nov 13 04:15:13 2007 -0800

    Makefile: VERSION=0.4.1

and I definitely had seen patches on sparse maillist since then (hell,
sent several myself - including fixes for show_typename(), etc.)

I don't mind doing more liberal ICE handling, *if* we agree on a well-defined
extensions to what C99 says.  But I'd rather have some idea of what's pending
the inclusion into the tree...

As for the extensions...  Amend 6.6p6 in a way similar to 6.6p3 (i.e. allow
any junk in unevaluated subexpressions)?  Making that option-controlled,
probably...

BTW, gcc is very definitely buggy - int a[1 + 0 * x]; is accepted and
that breaks even 6.6p3, let alone 6.6p6.  With -pedantic -std=c99 -Wall,
at that.
