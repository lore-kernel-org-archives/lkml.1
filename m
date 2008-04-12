Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYDLN2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYDLN2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 09:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbYDLN16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 09:27:58 -0400
Received: from 1wt.eu ([62.212.114.60]:2562 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYDLN15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 09:27:57 -0400
Date: Sat, 12 Apr 2008 15:22:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: cs044024@mnnit.ac.in, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: modifying CFS failure
Message-ID: <20080412132235.GC8474@1wt.eu>
References: <42423.210.212.49.15.1207972006.squirrel@mail.mnnit.ac.in> <1208002923.7427.5.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208002923.7427.5.camel@twins>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 02:22:03PM +0200, Peter Zijlstra wrote:
> Please provide it as a series of patches against sched-devel/latest.
> 
> Just plain AVL code and a huge modified CFS backport make it impossible
> to tell what changed and why.
> 
> Which brings us to the question: _why_. That is, why are you trying to
> replace the rb-tree with an avl tree? Just because the worst case depth
> of the avl is slightly better than for an rb-tree, which can be offset
> by the slightl more expesive balance operations.

I would add that in the past, I too tried to replace the rbtree in order
to provide O(1) node deletion time. The tree was not balanced at all
(which provided faster operations). But the net result was very small
(maybe 1%, I don't remember exactly). The reason was that in practise,
the CFS rbtree does not change *that* often, and the pointer to the
first node already provides a great boost. I remember I had to play
in the area of millions of context-switches/s to see a difference, so
it was quite pointless (though the exercise itself was interesting).

> I'm glad people are working on CFS - its an interesting piece of the
> kernel after all, but provide it in a regular patch series, this is
> impossible to work with, sorry.

agreed.

Willy

