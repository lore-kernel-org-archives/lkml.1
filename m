Return-Path: <linux-kernel-owner+w=401wt.eu-S1760491AbYFLWY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760491AbYFLWY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756854AbYFLWYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:24:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:23834 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbYFLWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:24:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ezCNFPqowmvEhtk+j1g/WberuA5p5wa+w5G96XWr2Vk7J4/nizXEtWqLwVM8Swz2AN
         x6ns2KxLF69LDuLge70+f3EiV9DQ58aGinf9+Ub2b2t9+ciDVeMVLqLZNIPJOT5hbdLF
         u7vvja7SYFgNVdjCi1NfigLVdQsYbsgfxMPao=
Date: Fri, 13 Jun 2008 00:24:58 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueues: insert_work: use "list_head *" instead of
	"int tail"
Message-ID: <20080612222458.GC2472@ami.dom.local>
References: <20080612165120.GA12177@tv-sign.ru> <20080612165550.GA12183@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612165550.GA12183@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 08:55:50PM +0400, Oleg Nesterov wrote:
> On 06/12, Oleg Nesterov wrote:
> >
> > insert_work() inserts the new work_struct before or after cwq->worklist,
> > depending on the "int tail" parameter. Change it to accept "list_head *"
> > instead, this shrinks .text a bit and allows us to insert the barrier
> > after specific work_struct.
> 
> This allows us to implement
> 
> 	int flush_work(struct work_struct *work)
> 	{
...
> 	}
> 
> suggested by Peter. It only waits for selected work_struct.
> 
> I doubt it will have a lot of users though. In most cases we need
> cancel_work_sync() and nothing more.

I guess it could've had enough users if it were done a bit sooner...

I didn't check this implementation yet, but if it's "rtnl_lock in
other works" safe then it could've been used in David Miller's fresh
patch replacing last uses of flush_scheduled_work() in net drivers'
->stop() etc (thread: "Re: 2.6.25rc7 lockdep trace") - there would
be far less doubts about possible change of functionality.

Anyway, this idea looks right to me.

Thanks,
Jarek P.
