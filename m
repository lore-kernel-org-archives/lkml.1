Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYBSQlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYBSQlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYBSQlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:41:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867AbYBSQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:41:07 -0500
Date: Tue, 19 Feb 2008 08:38:53 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: Linux 2.6.25-rc2
In-Reply-To: <20080219172739.55c341b5.dada1@cosmosbay.com>
Message-ID: <alpine.LFD.1.00.0802190835390.7833@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <20080219172739.55c341b5.dada1@cosmosbay.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Feb 2008, Eric Dumazet wrote:
> 
> cmpxchg_local(&c->freelist, object, object[c->offset]) can succeed,
> while an interrupt came (on this cpu), and several allocations were done,
> and one free was performed at the end of this interruption, so 'object'
> was recycled.

I think you may well be right. This looks like a good clue.

I'll do the revert. I wanted either a confirmation that reveting it 
actually fixes something, _or_ an actual bug description, and this seems 
to be a quite possible case of the latter.

			Linus
	
