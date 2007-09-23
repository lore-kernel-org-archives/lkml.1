Return-Path: <linux-kernel-owner+w=401wt.eu-S1757776AbXIWRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbXIWRL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 13:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXIWRLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 13:11:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51147 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755930AbXIWRLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 13:11:21 -0400
Date: Sun, 23 Sep 2007 10:05:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
cc: Dave Jones <davej@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: memset as memzero
In-Reply-To: <20070923160750.GO4887@ghostprotocols.net>
Message-ID: <alpine.LFD.0.999.0709230956040.16478@woody.linux-foundation.org>
References: <20070922083355.GA7226@cvg> <20070922124659.741cca42@laptopd505.fenrus.org>
 <alpine.LFD.0.999.0709221149480.16478@woody.linux-foundation.org>
 <20070923153243.GE8127@redhat.com>
 <20070923160750.GO4887@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Sep 2007, Arnaldo Carvalho de Melo wrote:
> 
> bzero! That is it, its nothing new, just a sane name to something [..]

No, please no!

The BSD memory functions are nasty. If you do bzero, you logically should 
do the others too, and they are way inferior to the standard ones. Let's 
not go there.

Besides, if we want to avoid mistakes, I would suggest going to a much 
higher level. Ie more along the lines of also fixing the size and 
alignment, and using something like

	#define memclear(p) memset(p, 0, sizeof(*(p)))

because if you actually do something like

	git grep 'memset.*,[ 	]*0[ 	]*,'

(those [..] things contatain a space and a tab), you'll see that a *lot* 
of them share that pattern. 

Not that I think it's really worth it.

		Linus
