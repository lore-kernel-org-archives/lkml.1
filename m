Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYJFDr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYJFDr3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 23:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYJFDrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 23:47:21 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:13730 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbYJFDrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 23:47:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqACABMn6Uh5LF82iGdsb2JhbACTWgEBARUipDeBaoMj
X-IronPort-AV: E=Sophos;i="4.33,366,1220193000"; 
   d="scan'208";a="220989299"
Date: Mon, 6 Oct 2008 14:18:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: Bodo Eggert <7eggert@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081006031829.GQ30001@disturbed>
Mail-Followup-To: Aaron Carroll <aaronc@gelato.unsw.edu.au>,
	Bodo Eggert <7eggert@gmx.de>, Jens Axboe <jens.axboe@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <bimJN-4cO-5@gated-at.bofh.it> <biosl-6bq-9@gated-at.bofh.it> <biqkw-aK-3@gated-at.bofh.it> <birgx-1pQ-9@gated-at.bofh.it> <bisPe-3xx-9@gated-at.bofh.it> <bisYW-3HQ-13@gated-at.bofh.it> <E1KlQ9s-0003Oh-Cz@be1.7eggert.dyndns.org> <20081002233426.GG30001@disturbed> <48E71EFC.7040403@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E71EFC.7040403@gelato.unsw.edu.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 04, 2008 at 05:45:00PM +1000, Aaron Carroll wrote:
> Dave Chinner wrote:
>> On Thu, Oct 02, 2008 at 05:32:04PM +0200, Bodo Eggert wrote:
>>> Sounds like you need a priority class besides sync and async.
>>
>> There's BIO_META now as well, which I was testing at the same time
>> as RT priority. Marking all the metadata I/O as BIO_META did help,
>> but once again I never got to determining if that was a result of
>> the different tagging or the priority increase.
>
> What exactly do you want META to mean?  Strict prioritisation over
> all other non-META requests, or just more frequent and/or larger
> dispatches?  Should META requests be sorted?

The real question is "what was it supposed to mean"? AFAICT, it was
added to a couple of filesystems to be used to tag superblock read
I/O. Why - I don't know - there's a distinct lack of documentation
surrounding these bio flags. :/

Realistically, I'm not sure that having a separate queue for
BIO_META will buy us anything, given that noop is quite often the
fastest scheduler for XFS because it enables interleaved metadata
I/O to be merged with data I/O. Like I said, I was not able to spend
the time to determine exactly how BIO_META affected I/O patterns, so
I can't really comment on whether it is really necessary or not.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
