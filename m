Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYH2Q26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYH2Q26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYH2Q2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:28:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44918 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751743AbYH2Q2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:28:48 -0400
Date: Fri, 29 Aug 2008 17:11:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org>
	<20080829080809.0e42a323@infradead.org>
	<alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "schedule_timeout()", there's a big difference between asking for two 
> ticks and asking for two seconds. The latter should probably try to round 
> to a nice timer tick basis for power reasons).

I disagree - that is fixing the problem in the wrong place. The timer
structure needs an accuracy field of some form that the existing timer
functions initialise to 0.

On a heavily loaded system with things like network events the behaviour
of the overall system is too complex to do the job well except at the
timer level which seems all. At the virtualisation level the hypervisor
needs to be doing the work to merge timer events between guests for power
management.

Once the timers have an accuracy representation there doesn't need to be
any real difference anywhere in the stack.

Alan
