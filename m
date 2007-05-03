Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbXECTDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbXECTDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXECTDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:03:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:53543 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbXECTDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oG/BJ4gvVPM+/Y6+UCBfQsXtwKq6t3AS4xDx4zPvn8gKf0VqY5cwLsevqj9to2oQUxRqYuAf5LfMm+TvMo8+vJ13LleEd5Wm816yhIpe5Ajd4u5IrJ+46jUbLjNriX+uWFnzCCYXGmf1hHi1+E91dUUp1IA3+UfIOHejzeeuZxE=
Message-ID: <a36005b50705031203w14df6f1fp26e186056b0fdef7@mail.gmail.com>
Date: Thu, 3 May 2007 12:03:35 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
	 <4638C37D.7050503@haxent.com.br>
	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
	 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
	 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
	 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
	 <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
	 <Pine.LNX.4.64.0705031111320.6502@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Davide Libenzi <davidel@xmailserver.org> wrote:
>
> I thought you were talking about the poll/epoll interface in general, and
> the approach on how to extend it for the very few cases that ppl asks for.
> but I see we're focusing on futexes ...

Futexes must be part of the whole approach.  If they cannot sanely be
integrated the whole approach is more than questionable IMO.


> I'm not sure if futexes are the best approach to do that, but a way for
> the user to signal an event into a main event loop is needed.

I haven't necessarily seen much of this demand and, as you pointed out
yourself, there is already a completely valid and POSIX compliant way
to achieve that.  The situation would be very different if you
couldn't reliably implement this.

I don't suggest this as a long term solution, it's neither nice nor
fast.  But it is a way to achieve the goal until a real soution comes
along.  Signals cannot serve as a justification for introducing these
new concepts.


> IMO it is better to leave futexes alone. They are great for syncronizing
> MT apps, but do not properly fit an fd-based solution. For that, something
> like eventfd is enough.

That's ridiculously short-sighted.  All objects upon which one can
wait must be unified.  This is possible.  The kevent interface gives
enough flexibility.


Let's just finish the design and implementation of the real solution.
Be it kevent (modified to meet the last comments, I think I still have
some myself), or something completely different which you can propose.
 Then all programs which really care about performance can use that
code.

If a program doesn't care about performance then they might just as
well use pipes in signal handlers.
