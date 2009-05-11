Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbZEKHxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbZEKHxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZEKHwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:52:54 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51246 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbZEKHwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:52:53 -0400
Date: Mon, 11 May 2009 09:52:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: [GIT PATCH] block: unify request processing model and
	implement peek/fetch
Message-ID: <20090511075253.GH4694@kernel.dk>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08 2009, Tejun Heo wrote:
> Hello,
> 
> Upon ack, please pull from the following git tree.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-peek-fetch
> 
> Block layer has allowed two different models of request processing.
> elv_next_request() is used to peek at the top of the queue, after
> peeking, a LLD could start processing it immediately or dequeue and
> then start processing.
> 
> The non-dequeuing behavior is mostly useful for simpler device drivers
> (usually PIO based) which process requests on segment basis.  By using
> the block layer queue tip as the current request pointer, they don't
> have to care about request boundaries and just process things
> segment-by-segment.
> 
> However, this dual mode of operations complicates and ambiguates block
> layer API.  Block layer can't tell whether a request has begun
> processing or not in deterministic manner.  This makes accounting
> inaccurate and implementing high level features in block layer
> difficult.  For example, it isn't clear when a block layer timeout
> timer should be started or how queue queiscing for EH should be
> implemented.  Even when problems can be worked aroudn, it makes the
> implementation fragile.
> 
> Although allowing llds ignore request boundaries makes things simpler
> for certain drivers, the number of drivers benefit form it aren't too
> many and driver stacks which are even mildly complex have to deal with
> request boundaries anyway.  Also, the benefit itself isn't that
> significant.  In most cases, it is just another way of doing things
> rather than the definitively better way.  IOW, if there were no such
> alternative, nobody would have missed it.
> 
> This patchset converts all block layer llds to dequeuing model and
> then clean up API to simplify a bit and enforce dequeueing model.
> This patchset contains the following patches.

Glad this finally got completed, thanks a lot Tejun! Applied.

-- 
Jens Axboe

