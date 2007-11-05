Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbXKEN4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbXKEN4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 08:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbXKEN4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 08:56:34 -0500
Received: from nic2.axis.se ([193.13.178.10]:57755 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbXKEN4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 08:56:33 -0500
Date: Mon, 5 Nov 2007 14:56:21 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRIS v10 serial driver rewrite take two
Message-ID: <20071105135621.GM7621@axis.com>
References: <20071105131148.GK7621@axis.com> <472F1E7B.8060304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472F1E7B.8060304@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 02:45:31PM +0100, Jiri Slaby wrote:
> On 11/05/2007 02:11 PM, Jesper Nilsson wrote:
> >  	if (tty_hung_up_p(filp) ||
> >  	    (info->flags & ASYNC_CLOSING)) {
> >  		if (info->flags & ASYNC_CLOSING)
> 
> You can remove this (__^) line now, the test itself is inside
> wait_event_interruptible macro yet.

Ah, yes, so it is.

> > -			interruptible_sleep_on(&info->close_wait);
> > +			wait_event_interruptible(info->close_wait,
> > +				!info->flags & ASYNC_CLOSING);
> 
> This is still buggy, I intentionally put the parenthesis around "info->flags &
> ASYNC_CLOSING" in my previous mail. This way it will ever evaluate to 0 (since
> it is as same as (!info->flags) & ASYNC_CLOSING now).

Of course. I thought about it, but obviously my brain used teflon-coated
memory to store that information. I'll be back with yet another version.

> Jiri Slaby (jirislaby@gmail.com)

Thanks again for you comments,

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
