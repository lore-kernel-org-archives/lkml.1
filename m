Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYJBNbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYJBNbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYJBNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:30:07 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47274 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285AbYJBNaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:30:05 -0400
Date: Thu, 2 Oct 2008 15:27:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002132746.GG19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <87fxnfpjqj.fsf@basil.nowhere.org> <20081002075511.GX19428@kernel.dk> <20081002093326.GF30001@disturbed> <20081002094537.GA19428@kernel.dk> <20081002061433.4e995075@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002061433.4e995075@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Arjan van de Ven wrote:
> On Thu, 2 Oct 2008 11:45:37 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > 
> > That's a good idea, just bump the priority a little bit. Arjan, did
> > you test that out? I'd suggest just trying prio level 0 and still
> > using best-effort scheduling. Probably still need the sync marking,
> > would be interesting to experiment with though.
> 
> I looked at 0 but it appears the 0 is the default for everyone...
> if everyone just defaulted to > 0 then yes I would have picked 0.

That's not correct, class BE and value 4 is the default (and the code
defaults to that, if you haven't set a value yourself):

#define IOPRIO_NORM     (4)
static inline int task_ioprio(struct io_context *ioc)
{
        if (ioprio_valid(ioc->ioprio))
                return IOPRIO_PRIO_DATA(ioc->ioprio);

        return IOPRIO_NORM;
}

static inline int task_ioprio_class(struct io_context *ioc)
{
        if (ioprio_valid(ioc->ioprio))
                return IOPRIO_PRIO_CLASS(ioc->ioprio);

        return IOPRIO_CLASS_BE;
}

So if you use IOPRIO_CLASS_BE and 0 for the ioprio, you will have the
highest priority of the default scheduling class.

-- 
Jens Axboe

