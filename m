Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbXLHU4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbXLHU4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbXLHUz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:55:56 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:26121 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXLHUzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FatK5Rk0qlO7ym24FOpKzH3S4vVSjJ/EbzFBXyqqgkS4qj/W3SDhbPlm6L5tqjKSJbQrlra30VftqizXn+BQAjc0PqdgZMNRs4eDG3JUi64SsyoISVbEDTL1xNkzlaw2/AqRpBxKnp5t0yX9jIrNyzV66R6RT0IujPbRBY8agXQ=
Message-ID: <3efb10970712081255k7ceec2bev4932512b2e1cda89@mail.gmail.com>
Date: Sat, 8 Dec 2007 21:55:54 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
Cc: "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Dave Chinner" <dgc@sgi.com>
In-Reply-To: <1197147016.6353.53.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
	 <1197135413.6353.36.camel@lappy>
	 <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
	 <1197144276.6353.44.camel@lappy>
	 <3efb10970712081233q10ac7f6bwb2c0ab8107714c1c@mail.gmail.com>
	 <1197147016.6353.53.camel@lappy>
X-Google-Sender-Auth: 1bed737610bb3dff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Thanks for this clear answer.

Remy

2007/12/8, Peter Zijlstra <peterz@infradead.org>:
>
> On Sat, 2007-12-08 at 21:33 +0100, Remy Bohmer wrote:
>
> > Which problems? I did not see any special things, it looked rather
> > straight forward. What have I overlooked?
>
> On suspend it locks the whole device tree, this means it has 'unbounded'
> nesting and holds an 'unbounded' number of locks. Neither things are
> easy to annotate (remember that mutex_lock_nested can handle up to 8
> nestings and current->held_locks has a max of 30).
>
> In fact, converting this will be the hardest part, it would require
> reworking the locking and introduction of a hard limit on the device
> tree depth - this might upset some people, but I suspect that 16 or 24
> should be deep enough for pretty much anything. Of course, if people
> prove me wrong, I'll have to reconsider. The up-side of the locking
> scheme I'm thinking of will be that locking the whole tree will only
> take 'depth' number of opterations vs the total number of tree elements.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
