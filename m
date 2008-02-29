Return-Path: <linux-kernel-owner+w=401wt.eu-S1755772AbYB2RNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbYB2RNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYB2RNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:13:38 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbYB2RNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:13:37 -0500
Date: Fri, 29 Feb 2008 09:12:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0802290907480.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org> <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Michael Kerrisk wrote:

> >  What's the real advantage of this? I'm not seeing it. Just an extra
> >  complexity "niceness" that nobody can rely on anyway since it's not even
> >  specified, and older kernels won't do it.
> 
> The advantages are the following:
> 
> 1. We don't break the ABI.  in 2.6.23, RLIMIT_STACK acquired an
> additional semantic: RLIMIT_STACK/4 specified the size for
> argv+environ.

So maybe we should change *that* then, and just allow arg/env to be more 
than 25%.

> 2. It provides a sane mechanism for an application to determine the
> space available for argv+environ.  Formerly this space was an
> invariant, advertised via sysconf(_SC_ARG_MAX).

.. and what's the point? We've never had it before, nobody has ever cared, 
and the whole notion is just stupid. Why would we want to limit it? The 
only thing that the kernel *cares* about is the stack size - any other 
size limits are always going to be arbitrary.

> 3. The implementation details about stack size and size/location of
> argv+environ can be decoupled.

Now, this is a potentially interesting argument, but is it true (ie don't 
we have programs that know about the status quo) and are people actually 
planning on doing that (for what reason?) or is it just a theoretical one?

		Linus
