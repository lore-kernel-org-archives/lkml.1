Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYAJGXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYAJGXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 01:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYAJGXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 01:23:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47363 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbYAJGXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 01:23:41 -0500
Date: Wed, 9 Jan 2008 22:23:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: speed setup failure reporting
Message-Id: <20080109222352.c112b4eb.akpm@linux-foundation.org>
In-Reply-To: <20080103165507.3fe5b7a4@lxorguk.ukuu.org.uk>
References: <20080103165507.3fe5b7a4@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jan 2008 16:55:07 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Invalid speeds are forced to 9600. Update the code for this to encode new
> style baud rates properly.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/drivers/serial/serial_core.c linux-2.6.24-rc6-mm1/drivers/serial/serial_core.c
> --- linux.vanilla-2.6.24-rc6-mm1/drivers/serial/serial_core.c	2008-01-02 16:04:23.000000000 +0000
> +++ linux-2.6.24-rc6-mm1/drivers/serial/serial_core.c	2008-01-02 16:17:50.000000000 +0000
> @@ -372,7 +372,8 @@
>  		 */
>  		termios->c_cflag &= ~CBAUD;
>  		if (old) {
> -			termios->c_cflag |= old->c_cflag & CBAUD;
> +			baud = tty_termios_baud_rate(old);
> +			tty_termios_encode_baud_rate(termios, baud, baud);
>  			old = NULL;
>  			continue;
>  		}
> @@ -381,7 +382,7 @@
>  		 * As a last resort, if the quotient is zero,
>  		 * default to 9600 bps
>  		 */
> -		termios->c_cflag |= B9600;
> +		tty_termios_encode_baud_rate(termios, 9600, 9600);
>  	}
>  
>  	return 0;

Is this a 2.6.24 thing?
