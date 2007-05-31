Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbXEaT7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbXEaT7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761857AbXEaT7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:59:44 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761561AbXEaT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:59:42 -0400
Date: Thu, 31 May 2007 12:59:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
In-Reply-To: <Pine.LNX.4.64.0705311205520.30485@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0705311256230.26602@woody.linux-foundation.org>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0705311123370.30485@alien.or.mcafeemobile.com>
 <465F170B.3070603@redhat.com> <Pine.LNX.4.64.0705311144290.30485@alien.or.mcafeemobile.com>
 <20070531190235.GY4033@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0705311205520.30485@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 May 2007, Davide Libenzi wrote:
> 
> What I meant, was that the vast majority of MT+exec apps wants all their 
> fds (but an handfull, maybe) to be O_CLOEXEC. So a global, 
> non-inheritable, per-process flag seemed the most straightforward 
> solution.

I'm with Uli on this one. "Stateful" stuff is bad. It's essentially 
impossible to handle with libraries - either the library would have to 
explciitly always turn the state the way _it_ needs it, or the library 
will do the wrogn thing.

For example, what about libraries that are used to set up stdin/stdout for 
the forker?

This is not unlike floating point rounding. Having stateful rounding (like 
the i387) is *stupid*. You want per-operation rounding (where *one* of the 
choices may be "use default"). Exactly because libraries etc will need to 
control their _own_ internal choices.

		Linus
