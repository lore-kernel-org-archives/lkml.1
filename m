Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbXBSOcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbXBSOcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXBSOcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:32:55 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:22022 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbXBSOcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:32:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:sender;
        b=QGEeqnzVqxgCTr5rv/x6sMOg7eIzInfOcg5BJ3RbiT+GR1LU9mxLAU32yAYCK2HXOB6pTZ/81Ju4fv6otohSYHNDacKBZn6jCOVvAi66RSsZODRRgyVPi4XaYBuhI67RGchIbrkrUqAaOt6SutjE+ro057jV6Bb0V7Pl96AV6RA=
Date: Tue, 20 Feb 2007 14:32:01 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mattia Dongili <malattia@linux.it>,
       Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [-mm patch] fix locking in __make_request (was Re: 2.6.20-mm2: Oops in generic_make_request)
Message-ID: <20070220143201.GH566@slug>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <45D84F73.8060904@free.fr> <20070218175805.GB5567@inferi.kami.home> <20070218114903.a8160301.akpm@linux-foundation.org> <6bffcb0e0702181205v5755fc0es284c5be32f85d304@mail.gmail.com> <20070220130408.GB566@slug> <6bffcb0e0702190552r67f878csb5e5c49dfa7c050c@mail.gmail.com> <45D9AF43.6010406@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45D9AF43.6010406@googlemail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 03:08:03PM +0100, Michal Piotrowski wrote:
> Michal Piotrowski napisał(a):
> > Hi Frederik,
> > 
> > On 20/02/07, Frederik Deweerdt <deweerdt@free.fr> wrote:
> >> Hi Michal,
> >>
> >> This seems to be a locking problem in __make_request, check_plug_merge()
> >> should be called with the q->queue_lock held.
> >> Could you try the following patch? It silenced the oops for me.
> > 
> > For me too, but Jens dislikes this patch.
> 
> Now I know why...
> 
> Code:  Bad EIP value.
> EIP: [<6b6b6b6b>] 0x6b6b6b6b SS:ESP 0068:f45f9bf8

:) It may not be related though. I think that my patch avoids the
BUG_ON(!rq_mergeable(req)); in ll_rw_blk.c:2782. This looks like another
beast to me.

Regards,
Frederik
