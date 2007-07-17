Return-Path: <linux-kernel-owner+w=401wt.eu-S934859AbXGQTY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859AbXGQTY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbXGQTYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:24:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbXGQTYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:24:50 -0400
Date: Tue, 17 Jul 2007 12:24:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Simmons <jsimmons@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux console project <linuxconsole-dev@lists.sourceforge.net>
Subject: Re: [PATCH] Use tty_schedule in VT code. 
In-Reply-To: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
Message-ID: <alpine.LFD.0.999.0707171222060.27353@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0707171933180.6721@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ Alan added to participants list, since he's in charge of tty code ]

On Tue, 17 Jul 2007, James Simmons wrote:
> diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
> index de37ebc..34894e5 100644
> --- a/drivers/char/tty_io.c
> +++ b/drivers/char/tty_io.c
> @@ -559,7 +559,7 @@ void tty_schedule_flip(struct tty_struct *tty)
>  	if (tty->buf.tail != NULL)
>  		tty->buf.tail->commit = tty->buf.tail->used;
>  	spin_unlock_irqrestore(&tty->buf.lock, flags);
> -	schedule_delayed_work(&tty->buf.work, 1);
> +	schedule_delayed_work(&tty->buf.work, 0);

Is there any real reason for this?

I think that patch is bogus. Either it should stay at 1, or the whole work 
should be a non-scheduled one instead.

Do we really need to handle it asap for the console, or is it ok to wait 
for the next tick, like the regular tty case used to?

And if we need to handle it asap, why the "delayed"?

		Linus
