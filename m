Return-Path: <linux-kernel-owner+w=401wt.eu-S968339AbYD1XHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968339AbYD1XHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935254AbYD1WpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:45:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935234AbYD1WpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:45:21 -0400
Date: Tue, 29 Apr 2008 00:44:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080428224438.GA6974@elte.hu>
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu> <48164EE6.8010506@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48164EE6.8010506@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> What I'm proposing is:
>
> >   [ .... fastpath head ......     ]
> >   [ ....   5-byte CALL .......... ]  ---> NOP-ed out
> >   [ .... fastpath tail .......... ]
> >   [ ............................. ]
>
> The call site is created with an asm() statement as opposed to a gcc 
> function call; it is up to the logging function to take the state and 
> mangle it into whatever format it wants to; the debugging information 
> (e.g. DWARF) should tell it all it needs to know about how the 
> register/memory state maps onto the C state.  This mapping can either 
> be done online, with a small piece of dynamic code, or offline 
> (although offline makes it tricky to know what memory tems to gather.)

that would be rather impractical as we'd force DEBUG_INFO builds on 
anyone (it's HUGE) just to do some trivial tracing. Look at the ftrace 
plugin usage model - it wants to be widely available and easy to use.

	Ingo
