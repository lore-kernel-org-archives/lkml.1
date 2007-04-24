Return-Path: <linux-kernel-owner+w=401wt.eu-S1161821AbXDXPJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161821AbXDXPJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161822AbXDXPJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:09:12 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:56665 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161821AbXDXPI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RkVSTVZK9kmYO4fj2uApA70Mh9YsxmWxoYcQlaQV9zbtpRVkQ+1BmjiP7CIA+g9juta6MjB99xDhTRjeoLDIE873fzyj4VwHwFNkjnnuZ2nViv3k/qDCx/wCkkFhf0FZ15CbXiW8dtadBoi4QqiLnd6MtuvCo8wmcHLlsXuuoGo=
Message-ID: <2c0942db0704240808p5b97bb31u42da4db298821809@mail.gmail.com>
Date: Tue, 24 Apr 2007 08:08:56 -0700
From: "Ray Lee" <madrabbit@gmail.com>
Reply-To: ray-gmail@madrabbit.org
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Juliusz Chroboczek" <jch@pps.jussieu.fr>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Bill Davidsen" <davidsen@tmr.com>, "Willy Tarreau" <w@1wt.eu>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, caglar@pardus.org.tr,
       "Gene Heskett" <gene.heskett@gmail.com>
In-Reply-To: <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070420140457.GA14017@elte.hu>
	 <200704220155.20856.kernel@kolivas.org>
	 <20070421160008.GA28783@elte.hu>
	 <200704220959.34978.kernel@kolivas.org>
	 <87647oblx5.fsf@pps.jussieu.fr>
	 <alpine.LFD.0.98.0704221620310.9964@woody.linux-foundation.org>
	 <20070423013429.GB25162@wotan.suse.de>
	 <alpine.LFD.0.98.0704230844410.9964@woody.linux-foundation.org>
	 <20070423191143.GA16849@elte.hu>
	 <alpine.LFD.0.98.0704231227300.9964@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, 23 Apr 2007, Ingo Molnar wrote:
> >
> > The "give scheduler money" transaction can be both an "implicit
> > transaction" (for example when writing to UNIX domain sockets or
> > blocking on a pipe, etc.), or it could be an "explicit transaction":
> > sched_yield_to(). This latter i've already implemented for CFS, but it's
> > much less useful than the really significant implicit ones, the ones
> > which will help X.
>
> Yes. It would be wonderful to get it working automatically, so please say
> something about the implementation..
>
> The "perfect" situation would be that when somebody goes to sleep, any
> extra points it had could be given to whoever it woke up last. Note that
> for something like X, it means that the points are 100% ephemeral: it gets
> points when a client sends it a request, but it would *lose* the points
> again when it sends the reply!

It would seem like there should be a penalty associated with sending
those points as well, so that two processes communicating quickly with
each other won't get into a mutual love-fest that'll capture the
scheduler's attention.

Ray
