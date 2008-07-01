Return-Path: <linux-kernel-owner+w=401wt.eu-S1758950AbYGAU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950AbYGAU7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbYGAU7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:59:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:36253 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYGAU7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o2RT2erXEd2fIcuSz2pPZv1zNU2FKqpQiWS+ByBBmp0widBB96JON9YuEEta43zAfR
         7BFIzj1V/agn1Kz3EtugRLxNhDHD+8PpuUlgtz7N79oVfvUN7Gi++Mfv4nymHkQz9BrK
         rt9lzrC8l5scbcLlmkqOPleBLpn0j3HzzeY90=
Date: Tue, 1 Jul 2008 23:03:00 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: implement flush_work()
Message-ID: <20080701210300.GA3272@ami.dom.local>
References: <20080629144926.GA4347@tv-sign.ru> <20080630132512.GA2663@ami.dom.local> <20080701125018.GA99@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701125018.GA99@tv-sign.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 04:50:18PM +0400, Oleg Nesterov wrote:
...
> Yes, cwq can be "stale", but this doesn't matter and we can't have
> the false positive here.
> 
> cwq->current_work is always changed under cwq->lock, and we hold this
> lock. If we see "cwq->current_work == work" we can safely insert the
> barrier and wait. Even if this work was already re-queued on another
> CPU or another workqueue_struct.
> 
> Note also that rmb() can't really help here.

Right! The question is how "stale" this cwq could be when read without
any lock or barrier. Of course, there can't be the false positive, but
I wonder if we really do enough, to check if a work isn't current on
some other cwq, even without any immediate re-queuing.

Thanks for the explanation,
Jarek P.
