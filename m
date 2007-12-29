Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXL2Cim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXL2Cim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbXL2Cie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:38:34 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47165 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753087AbXL2Cid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:38:33 -0500
Date: Sat, 29 Dec 2007 02:29:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] mxser, remove it
Message-ID: <20071229022930.2c66c694@the-village.bc.nu>
In-Reply-To: <1198836540-8042-1-git-send-email-jirislaby@gmail.com>
References: <1198836540-8042-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (cmd == MOXA_SET_SPECIAL_BAUD_RATE) {
> +		int speed;
> +
> +		if (get_user(speed, (int __user *)argp))
> +			return -EFAULT;
> +		if (speed <= 0 || speed > info->max_baud)
> +			return -EFAULT;

-EINVAL

> +		if (!info->tty || !info->tty->termios || !info->ioaddr)
> +			return 0;

!info->tty and !info->tty->termios can't happen

> +		info->tty->termios->c_cflag &= ~(CBAUD | CBAUDEX);

No...

> +		for (i = 0; i < BAUD_TABLE_NO; i++)
> +			if (speed == mxvar_baud_table[i])
> +				break;
> +		if (i == BAUD_TABLE_NO) {
> +			info->tty->termios->c_cflag |= B_SPEC;
> +		} else if (speed != 0)
> +			info->tty->termios->c_cflag |= mxvar_baud_table1[i];

Replace all the above mess with a single tty_encode_baud_rate call

