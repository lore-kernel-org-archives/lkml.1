Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbYKQS2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbYKQS2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYKQS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:28:41 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:43545 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYKQS2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:28:41 -0500
Date: Mon, 17 Nov 2008 19:26:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <htejun@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix kunmap() argument in sg_miter_stop
Message-ID: <20081117182650.GY26778@kernel.dk>
References: <20081117093425.GG26778@kernel.dk> <20081117094147.GJ28786@elte.hu> <20081117094551.GI26778@kernel.dk> <20081117111350.GJ26778@kernel.dk> <4921A4F3.1030309@goop.org> <20081117171005.GA25729@elte.hu> <4921A6BE.7000206@goop.org> <alpine.LFD.2.00.0811170922000.3468@nehalem.linux-foundation.org> <20081117180738.GW26778@kernel.dk> <alpine.LFD.2.00.0811171015070.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811171015070.3468@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17 2008, Linus Torvalds wrote:
> 
> 
> On Mon, 17 Nov 2008, Jens Axboe wrote:
> > 
> > Any opinions on the kunmap/kunmap_atomic pointer checking? It's a bit
> > ugly that we have to enforce a void * rule for kunmap_atomic(),
> 
> I don't think that's a "bit ugly". I think it's unacceptable.
> 
> Making sure we pass in "struct page" to kunmap() sounds good, but the 
> kunmap_atomic() part just sounds insane.

It's been the primary source of bugs that I have seen. The xen and sg
iter bug were kunmap() variants though, but otherwise I've mostly seen
the opposite. But it is ugly, no doubt about it. I can't think of a
better way to attempt to warn about it though, so if you really dislike
it I'll just drop the _atomic() bits.

-- 
Jens Axboe

