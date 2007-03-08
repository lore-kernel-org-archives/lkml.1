Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbXCHHY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbXCHHY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 02:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXCHHY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 02:24:57 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:58001 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738AbXCHHY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 02:24:56 -0500
Message-ID: <45EFBA14.9090307@cosmosbay.com>
Date: Thu, 08 Mar 2007 08:24:04 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Kyle Moffett <mrmacman_g4@mac.com>
CC: "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Anton Blanchard <anton@samba.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org> <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com> <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com>
In-Reply-To: <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 08 Mar 2007 08:24:06 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett a écrit :
> 
> Prefetching is also fairly critical on a Power4 or G5 PowerPC system as 
> they have a long memory latency; an L2-cache miss can cost 200+ cycles.  
> On such systems the "dcbt" prefetch instruction brings in a single 
> 128-byte cacheline and has no serializing effects whatsoever, making it 
> ideal for use in a linked-list-traversal inner loop.

OK, 200 cycles...

But what is the cost of the conditional branch you added in prefetch(x) ?

if (!x) return;

(correctly predicted or not, but do powerPC have a BTB ?)

About the NULL 'potential problem', maybe we could use a dummy nil (but 
mapped) object, and use its address in lists, ie compare for &nil instead of 
NULL. This would avoid :

- The conditional test in some prefetch() implementations
- The potential TLB problem with the NULL value.




