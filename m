Return-Path: <linux-kernel-owner+w=401wt.eu-S935836AbYEUSv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935836AbYEUSv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 14:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756394AbYEUSvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 14:51:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbYEUSvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 14:51:46 -0400
Date: Wed, 21 May 2008 11:49:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signals: sigqueue_free: don't free sigqueue if it
 is queued
In-Reply-To: <20080521184245.5BABF26FA24@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0805211146350.3081@woody.linux-foundation.org>
References: <20080517151420.GA9496@tv-sign.ru> <20080521022046.1501F26FA1C@magilla.localdomain> <20080521115414.GA147@tv-sign.ru> <20080521184245.5BABF26FA24@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 May 2008, Roland McGrath wrote:
> 
> Just properly removing the sigqueue entry and fixing the pending set is
> looking pretty good.  Why was it we didn't do that?

I thought we didn't even know which queue it was pending on if it was 
already on a thread-local queue. So we could remove the entry, but I 
always objected to the games with the pending bit.

Just removing the entry I'm ok with, it was the (pointless and misleading) 
use of recalc_sigpending() that started the whole discussion. The fact 
that we then also have that "which signal is pending" bit in front of the 
queue was something that came up later.

		Linus
