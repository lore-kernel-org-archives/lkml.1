Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbXHGV61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbXHGV61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937563AbXHGVfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:35:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:42835 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937558AbXHGVf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mOYIfgHBeS2PEZohbudVY6RZoQOjqvC6r974YtVBCgGMk9gozIGV0024fB8Vql7Ivv91mEvOToRnD04G9ntJTjZ6nT8Z5LlqbbtzGQ/z/8TMNVYdHoh4RhDqHQb15Q9oD3ZX7xWYKXe86rZ6kiNgnB1Xp6ax5Mm7mlrlA63B/bo=
Message-ID: <f6ca9fed0708071435h31531279gb6ea0fc760be98df@mail.gmail.com>
Date: Tue, 7 Aug 2007 23:35:27 +0200
From: dragoran <drago01@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: allow non root users to set io priority "idle" ?
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070807204449.GA5245@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de>
	 <46B6F75D.1070808@gmail.com>
	 <20070806103553.GA16133@one.firstfloor.org>
	 <20070807204449.GA5245@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

so there is no real reason not to allow it for non root users?
removing the check is easy (3 lines) ....
or are there any other issues/problems?

On 8/7/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Aug 06 2007, Andi Kleen wrote:
> > > couldn't this be fixed by bumping idle tasks to middle while they hold a
> >
> > Usually to high.
> >
> > But it's all complicated and hasn't been done consistently
> > (there are real time mutexes in the -rt kernel for example,
> > but there are lots of other locks and they have higher overhead too)
> > and it's unclear we really want to do all this complexity anyways.
> >
> > Also as I said the problem could then still happen in user space
> > which then would all need to be fixed to handle PI too.
> >
> > In some cases the relationship is also not as simple as a single
> > lock. And for IO handling it would be likely quite hard.
> >
> > I personally always found idle priorities quite dubious because
> > even if they worked reliable for the CPU they will clear your cache/
> > load your memory controller and impact all other programs because
> > of this. And for the disk they will cause additional seeks which are
> > also very costly.
>
> But that is why the idle priority implementation in CFQ adds a grace
> period before idle prio tasks are run. So that concern should not be an
> issue, if so the grace period needs to be enlarged. That at least covers
> the seek side of things. If idle io tasks run, then the IO load on the
> system must be very low to zero. Hence other IO relevant resource
> contention isn't an iissue.
>
> --
> Jens Axboe
>
>
