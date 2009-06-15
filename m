Return-Path: <linux-kernel-owner+w=401wt.eu-S1764791AbZFORQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764791AbZFORQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbZFORQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:16:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764592AbZFORQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:16:41 -0400
Date: Mon, 15 Jun 2009 10:15:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <84144f020906150827k1b8c0ce4q5ed4d140f7ca869@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906151013080.3305@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906121317140.23840@gentwo.org>  <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI> 
 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>  <1245077891.23207.48.camel@penberg-laptop>  <alpine.DEB.1.10.0906151101580.23995@gentwo.org>  <1245078661.23207.50.camel@penberg-laptop> <84144f020906150827k1b8c0ce4q5ed4d140f7ca869@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Jun 2009, Pekka Enberg wrote:
> 
> Actually, there's a slight complication here. If I push gfp mask to
> __might_sleep(), lockdep_trace_alloc() and so on, the mask is
> effective _everywhere_ even outside of slab. Yes, it makes sense if we
> push the masking right down to the page allocator but I wonder if
> that's something we want to do at this point?

This actually doesn't sound like a complication to me, but a potential 
cleanup.

Right now we already have that magic "system_state" test in __might_sleep. 
Maybe we could get rid of that, and replace it with that test for gpf 
bits. So we'd have just _one_ magic special case, and it's directly 
related to memory allocation (which is really the reason for that system 
state thing too).

But maybe we have other reasons for that system_state special case, that 
are independent. I have not checked.

			Linus
