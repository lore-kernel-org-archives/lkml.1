Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZADMRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZADMRE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:17:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbZADMQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:16:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50889 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750803AbZADMQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:16:53 -0500
Date: Sun, 4 Jan 2009 12:16:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tollef Fog Heen <tfheen@err.no>
Cc: linux-kernel@vger.kernel.org, werner@cornelius-consult.de,
       frank@kingswood-consulting.co.uk
Subject: Re: [PATCH] Winchiphead 340/1: full baud rate and status/control
 line support
Message-ID: <20090104121652.35a33c4c@lxorguk.ukuu.org.uk>
In-Reply-To: <87iqovs740.fsf@qurzaw.linpro.no>
References: <87iqovs740.fsf@qurzaw.linpro.no>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (factor > 0xfff0) { /* Clamp */
> +		factor = 0xfff0;
> +		divisor = 0;
> +	}
> +
> +	t1 = factor;
> +	for (t2 = divisor; t2 <= CH341_BAUDBASE_DIVMAX; t2++)
> +		t1 >>= 3;
> +	baud = CH341_BAUDBASE_FACTOR / t1;
> +

Same question as before: Can baud really become zero at this point ? Also
for that matter what guarantees that t1 cannot become zero in this
computation ?


> +	if (baud && tty)
> +		tty_encode_baud_rate(tty, baud, baud);

The check for B0 (hangup) was done earlier (see set_termios). So if you
can end up with a requested baud rate being turned into 0 you need to
bump it up to 1. If not you don't need the test.

