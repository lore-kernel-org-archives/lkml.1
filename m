Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbYH2Sqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbYH2Sqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 14:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYH2Sqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 14:46:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbYH2Sq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 14:46:29 -0400
Date: Fri, 29 Aug 2008 11:46:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
In-Reply-To: <20080829191837.3d2b3050@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.1.10.0808291140010.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org> <20080829080809.0e42a323@infradead.org> <alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org> <20080829171108.63e6dcd4@lxorguk.ukuu.org.uk> <alpine.LFD.1.10.0808291009450.3300@nehalem.linux-foundation.org>
 <20080829191837.3d2b3050@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Alan Cox wrote:
> 
> Most of the timers we want to aggregate with are kernel originated and
> those also need accuracy fields (tcp retransmit is fairly precision at
> high speed while tcp keepalive is 'yeah whatever' sort of urgency.

Actually, I disagree.

They are _both_ of the exact same type: the precision depends on how long 
the timeout is.

TCP retransmit timers are a perfect example. If the timeout is long (which 
is quite common if you end up having multiple retransmits), you _really_ 
don't care about how precise it is.

And keepalives are 'yeah whatever' exactly because they are so long, not 
because they are inherently uninteresting per se.

I suspect you could find some kernel-generated timer that doesn't fit that 
pattern, but I can't really think of any.

> Agreed except that I'd assume real time tasks implied high accuracy,
> otherwise one assumes they'd have not have been real time - and probably
> putting those constants into sysfs somewhere.

And yes, I do agree that the heuristic could well involve other 
characteristics of the process in question. And probably characteristics 
of the machine itself (ie some general kind of "power mode" where timers 
are simply not considered critical if you want to be in low-power mode).

		Linus
