Return-Path: <linux-kernel-owner+w=401wt.eu-S1754347AbYGZMh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbYGZMh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 08:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYGZMhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 08:37:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:49765 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbYGZMhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 08:37:14 -0400
Subject: Re: CONFIG_FRAME_POINTER [was [PATCH] x86: BUILD_IRQ say .text]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hugh Dickins <hugh@veritas.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Linuxppc-dev@ozlabs.org
In-Reply-To: <Pine.LNX.4.64.0807261122430.20543@blonde.site>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site>
	 <20080724104459.GI28817@elte.hu>
	 <Pine.LNX.4.64.0807251839190.20617@blonde.site>
	 <1217022373.11188.115.camel@pasglop>
	 <Pine.LNX.4.64.0807261122430.20543@blonde.site>
Content-Type: text/plain
Date: Sat, 26 Jul 2008 22:36:42 +1000
Message-Id: <1217075802.11188.129.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-26 at 12:02 +0100, Hugh Dickins wrote:
> 
> Hmm, perhaps it is doing sibling calls differently even without the
> explicit -fno-optimize-sibling-calls (but when I add that option,
> the vmlinux size does go up another 4400).
> 
> Sorry, I'm most probably fussing over nothing,
> and wasting your time with my ignorance.

No you aren't, there is indeed something happening. It looks like gcc is
keeping a copy of each stack frame in r31, thus forcing to save/restore
that register, along function calls, possibly to help get reliable
frames for leaf functions. I don't think we use that "feature" in our
backtrace code though... so it won't harm in the sense that it won't
break things, but it will indeed bloat the code a little bit.

Maybe we should totally disable -fno-omit-frame-pointers on powerpc ...
either that or see about actually using that r31 linkage, though I'm not
sure it would be that useful.

I'll have to talk to our toolchain folks to figure out exactly what's
going on there.

Cheers,
Ben.
 

