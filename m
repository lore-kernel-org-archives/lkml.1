Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYH2SgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYH2SgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYH2SgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:36:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37367 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751344AbYH2SgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:36:03 -0400
Date: Fri, 29 Aug 2008 19:18:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080829191837.3d2b3050@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org>
	<20080829080809.0e42a323@infradead.org>
	<alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
	<20080829171108.63e6dcd4@lxorguk.ukuu.org.uk>
	<alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
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

> I do agree that we could do that too, but you miss one big issue: even if 
> we were to add an accuracy field inside the kernel, there is no such field 
> in the user interfaces.

Most of the timers we want to aggregate with are kernel originated and
those also need accuracy fields (tcp retransmit is fairly precision at
high speed while tcp keepalive is 'yeah whatever' sort of urgency.

At the point we are merging timers we want to consider user kernel and in
a virtualised environment across all guest.

> We just pass timevals (and sometimes timespecs) around, and no, they don't 
> have any way to specify accuracy.

Agreed for userspace.

> Yeah, we could use the high bits in the usec/nsec words, but then older 
> kernels would basically do random things, so that would be a horrible 
> interface.

Gak.... no...

> And the only reasonable way to do that is to just look at the range. You 
> can probably do something fairly trivial with

Agreed except that I'd assume real time tasks implied high accuracy,
otherwise one assumes they'd have not have been real time - and probably
putting those constants into sysfs somewhere.


Alan
