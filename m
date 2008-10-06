Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYJFI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYJFI6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYJFI6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:58:09 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:51088 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbYJFI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:58:08 -0400
Date: Mon, 6 Oct 2008 10:58:06 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@redhat.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 67/76] tty: Remove lots of NULL checks
In-Reply-To: <20081005162321.1997.71337.stgit@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0810061055550.5594@anakin>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
 <20081005162321.1997.71337.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Alan Cox wrote:
> Many tty drivers contain 'can't happen' checks against NULL pointers passed
> in by the tty layer. These have never been possible to occur. Even more
> importantly if they ever do occur we want to know as it would be a serious
> bug.

> diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
> index ae377aa..c0a1df9 100644
> --- a/drivers/char/n_r3964.c
> +++ b/drivers/char/n_r3964.c
> @@ -372,15 +372,8 @@ static void remove_from_rx_queue(struct r3964_info *pInfo,
>  static void put_char(struct r3964_info *pInfo, unsigned char ch)
>  {
>  	struct tty_struct *tty = pInfo->tty;
> -
> -	if (tty == NULL)
> -		return;
> -
>  	/* FIXME: put_char should not be called from an IRQ */
> -	if (tty->ops->put_char) {
> -		tty->ops->put_char(tty, ch);
> -	}
> -	pInfo->bcc ^= ch;
        ^^^^^^^^^^^^^^^^
> +	tty_put_char(tty, ch);
>  }

I have no idea what this `bcc' thingy does, but its removal just struck
my eye...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
