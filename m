Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbYB2Sl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbYB2Sl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbYB2SlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:41:15 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759284AbYB2SlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:41:14 -0500
Date: Fri, 29 Feb 2008 10:39:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, Geoff Clare <gwc@opengroup.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
In-Reply-To: <47C84C6C.2000201@gmail.com>
Message-ID: <alpine.LFD.1.00.0802291032370.17889@woody.linux-foundation.org>
References: <1204119455.6242.403.camel@lappy>  <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>  <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>  <1204305244.6243.111.camel@lappy>  <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
 <1204307756.6243.121.camel@lappy> <47C84C6C.2000201@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Feb 2008, Michael Kerrisk wrote:
> 
> My reading of POSIX.1 (and POSIX doesn't seem very explicit on this point), is
> that the limits on argv+environ and on stack are decoupled, since POSIX
> specifies RLIMIT_STACK and sysconf(_SC_ARG_MAX) and doesn't specify any
> relationship between the two.

I agree. And clearly there _are_ relationships and always have been, but 
equally clearly they simply haven't been a big issue in practice, and 
nobody really cares.

Usually, _SC_ARG_MAX is just so much smaller than RLIMIT_STACK that it 
makes no possible difference.  Which I would actually argue we should just 
continue with: just keep _SC_ARG_MAX a smallish, irrelevant constant.

We still have to have the compile-time ARG_MAX constant (as in *real* 
constant - a #define) anyway, for traditional programs, and you might as 
well make sysconf(_SC_ARG_MAX) always just match ARG_MAX.

It's not like there is likely a single user of _SC_ARG_MAX that cares.

			Linus
