Return-Path: <linux-kernel-owner+w=401wt.eu-S2992907AbXCICwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992907AbXCICwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992909AbXCICwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:52:47 -0500
Received: from ozlabs.org ([203.10.76.45]:44634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992907AbXCICwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:52:46 -0500
Date: Thu, 8 Mar 2007 20:51:02 -0600
From: Anton Blanchard <anton@samba.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch] epoll use a single inode ...
Message-ID: <20070309025102.GC24695@kryten>
References: <45ED1A3C.6030707@argo.co.il> <200703071906.58405.dada1@cosmosbay.com> <Pine.LNX.4.64.0703071022390.5963@woody.linux-foundation.org> <200703071952.13219.dada1@cosmosbay.com> <20070307221401.GA16938@kryten> <Pine.LNX.4.64.0703071453080.5963@woody.linux-foundation.org> <f2b55d220703071725w7c09b93bgbf357aeb25a21c2b@mail.gmail.com> <6E1C86DF-D512-418C-B270-BC5C4316BC0A@mac.com> <45EFBA14.9090307@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EFBA14.9090307@cosmosbay.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> OK, 200 cycles...
> 
> But what is the cost of the conditional branch you added in prefetch(x) ?

Much less than the tablewalk. On ppc64 a tablewalk of an address that is
not populated in the hashtable will incur 2 cacheline lookups (primary
and secondary buckets). This plus the MMU state machine overhead adds up.

Cue Linus rant about PowerPC MMU :)

Anton
