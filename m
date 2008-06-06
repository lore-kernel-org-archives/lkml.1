Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbYFFUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbYFFUNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbYFFUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 16:13:13 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:29489 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755896AbYFFUNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 16:13:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jb1S38jazqcfJm99mdUHqp8xUxkcZVSMoZdMMeNemlEkWlI5VnR8T+taWNYayzCnWSd3VcErpAalRj2tkkbka5ihKWxvjQvztdc5cgfiLSXvkpAfOG2OafnmzSdsSSlVPa36H2NXQQXylwSbVPdPdGQRW4gQI+HWU755NPAOj34=  ;
X-YMail-OSG: lD4X8KMVM1lbGjUh9UCSaUE6kCwJyw8KyncFoL2rAywiyFc6dcnHU8CBB73RbqV2zFFDRQG52AZsAUZO4yepCiE181nFkJ1oAcrgJOWXopWlcWiVbXkYRUuoYs_1KhCXK88-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Locking in the (now generic) GPIO infrastructure?
Date: Fri, 6 Jun 2008 13:13:10 -0700
User-Agent: KMail/1.9.9
Cc: LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
References: <c384c5ea0806040400j35236d5fo3854ce2ed30cd755@mail.gmail.com> <200806060553.48057.david-b@pacbell.net> <c384c5ea0806061223k44a7db74hbdf2ed6f422442b2@mail.gmail.com>
In-Reply-To: <c384c5ea0806061223k44a7db74hbdf2ed6f422442b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806061313.11021.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008, Leon Woestenberg wrote:
> In fact, on the IXP4xx, gpio_set_value() is just gpio_line_set(),

OK, so the generic GPIO calls are inheriting a locking bug
from the older code.  Calls to the older stuff should probably
start getting phased out.


> so I 
> think it is valid to understand where the locking should occur (lowest
> level, higher level?)
> 
> > most spinlocks to establish its atomicity guarantee; it's
> > described as "spinlock-safe", and in distinction to the
> > gpio_set_value_cansleep() call which could use a mutex or
> > other sleeping synch primitive.
> >
> 
> So, the solution (for the upstream work on -rt) would be to add
> spinlock protection to gpio_line_set(), mutex protection for
> _cansleep() variants?

Given this is on -RT, yes it seems like a spinlock is needed
to protect against preemption (but not against concurrency,
which those XScale chips don't provide).

Though with that addition, the size of that function exceeds
what I'd call appropriate to inline.

- Dave

