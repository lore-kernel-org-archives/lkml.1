Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYJBNgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYJBNgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYJBNgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:36:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:36893 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbYJBNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:36:31 -0400
Date: Thu, 2 Oct 2008 06:36:06 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002063606.512decb3@infradead.org>
In-Reply-To: <20081002132746.GG19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<87fxnfpjqj.fsf@basil.nowhere.org>
	<20081002075511.GX19428@kernel.dk>
	<20081002093326.GF30001@disturbed>
	<20081002094537.GA19428@kernel.dk>
	<20081002061433.4e995075@infradead.org>
	<20081002132746.GG19428@kernel.dk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 15:27:47 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Oct 02 2008, Arjan van de Ven wrote:
> > On Thu, 2 Oct 2008 11:45:37 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > 
> > > That's a good idea, just bump the priority a little bit. Arjan,
> > > did you test that out? I'd suggest just trying prio level 0 and
> > > still using best-effort scheduling. Probably still need the sync
> > > marking, would be interesting to experiment with though.
> > 
> > I looked at 0 but it appears the 0 is the default for everyone...
> > if everyone just defaulted to > 0 then yes I would have picked 0.
> 
> That's not correct, class BE and value 4 is the default (and the code
> defaults to that, if you haven't set a value yourself):
> 
> #define IOPRIO_NORM     (4)
> static inline int task_ioprio(struct io_context *ioc)
> {
>         if (ioprio_valid(ioc->ioprio))
>                 return IOPRIO_PRIO_DATA(ioc->ioprio);
> 
>         return IOPRIO_NORM;
> }
> 
> static inline int task_ioprio_class(struct io_context *ioc)
> {
>         if (ioprio_valid(ioc->ioprio))
>                 return IOPRIO_PRIO_CLASS(ioc->ioprio);
> 
>         return IOPRIO_CLASS_BE;
> }
> 
> So if you use IOPRIO_CLASS_BE and 0 for the ioprio, you will have the
> highest priority of the default scheduling class.

ok

I checked not by looking at the code, but running ionice -p <pid> on a
bunch of things and they came back as 0 

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
