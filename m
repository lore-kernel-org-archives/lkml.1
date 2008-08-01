Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYHARlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYHARlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYHARk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:40:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbYHARk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:40:57 -0400
Date: Fri, 1 Aug 2008 10:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce down_try() so we can move away from
 down_trylock()
Message-Id: <20080801104046.e9e8d6fd.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org>
References: <200807291015.02865.rusty@rustcorp.com.au>
	<6599ad830807281727r63a57a1g11972c5395828aae@mail.gmail.com>
	<200807292301.18733.rusty@rustcorp.com.au>
	<alpine.LFD.1.10.0808011022230.3277@nehalem.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2008 10:26:33 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > I planned on removing the much-disliked down_trylock() (with its
> > backwards return codes) in 2.6.27, but it's creating something of a
> > logjam with other patches in -mm and linux-next.
> > 
> > Andrew suggested introducing "down_try" as a wrapper now, to make
> > the transition easier.
> 
> The transition to WHAT? To crap?
> 

The naming is pretty sad, but the inconsistent return value from
down_trylock() drives me batshit.  It means that every time I ever look
at any sort of trylock call I need to go back to the definition site to
work out if it's the one which returns true or if it's the one which
returns false.

It would be good to get that fixed.  And if we _do_ want to fix it, I
don't see any alternative to creating a new function.

