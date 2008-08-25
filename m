Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYHYSDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYHYSDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756636AbYHYSDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:03:25 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:60642 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615AbYHYSDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:03:24 -0400
Message-ID: <48B2F3E9.5020804@skyrush.com>
Date: Mon, 25 Aug 2008 12:03:21 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Willy Tarreau <w@1wt.eu>, Chris Frey <cdfrey@foursquare.net>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Visible Ctrl-C in latest kernels
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com> <20080824010231.GA26030@foursquare.net> <20080825122024.GA19337@1wt.eu> <48B2EDC2.1020608@davidnewall.com>
In-Reply-To: <48B2EDC2.1020608@davidnewall.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Willy Tarreau wrote:
>> I would not be surprized that it is what has caused delays for Ctrl-C
>> to take effect for some of us. As discussed in another thread on the
>> subject, the problem was relatively recent and not easy to reproduce.
>>   
> 
> I don't think so.  Joe Peterson raised A line of enquiry, which looked
> quite promising to me, in
> http://marc.info/?l=linux-kernel&m=121502197008293.  He observed weird
> behaviour with pgrp, and that doesn't seem to have been explored
> adequately.  I think it's worth highlighting that the code which sends
> the signal is the following snippet, from n_tty.c:
> 
>     if (tty->pgrp)
>             kill_pgrp(tty->pgrp, signal, 1);
> 
> 
> I wonder if pgrp has a value different than we expect?

David,

Subsequently, I determined that the issue I talked about in the above
referenced thread was a bug in bash.  Here is my post about this:

	http://marc.info/?l=linux-kernel&m=121537020432289&w=2

The bash author has developed a simple patch, and it should appear
(according to him) in the new bash version.

> I had an idea; it didn't work out as I expected, but it did produce a
> result that I can't immediately explain; and it might be relevant.  The
> following program, when executed in background (./testprogram &) stops
> at tcsetpgrp(), which is fine; and if then continued (fg), it is immune
> to the interrupt, quit and suspend keys.  However, it is not immune to
> those keys if executed in foreground (./testprogram).  As said, I can't
> immediately explain this, and it seems like it might be important...

When I run your program, foreground or background, it always completes
(i.e. 5 "." chars) - i.e., I cannot interrupt it before it finishes.
This seems different than what you see.

Given the nature of the bash issue, it does not seem related, at least
not directly.

						-Joe
