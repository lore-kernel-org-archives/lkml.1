Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZLWVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZLWVu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbZLWVu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:50:27 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53209
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249AbZLWVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:50:26 -0500
Date: Wed, 23 Dec 2009 13:50:28 -0800 (PST)
Message-Id: <20091223.135028.112586698.davem@davemloft.net>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 15/37] sparc,sunzilog: Add console polling support for
 sunzilog serial driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
	<1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
	<1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 23 Dec 2009 15:19:28 -0600

> +static void sunzilog_put_poll_char(struct uart_port *port,
> +			unsigned char ch)
> +{
> +	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *)port;
> +
> +	sunzilog_putchar(&up->port, ch);
> +	udelay(2);
> +
> +}
> +#endif /* CONFIG_CONSOLE_POLL */

Just curious, what is the udelay() for?

>  static struct uart_ops sunzilog_pops = {
>  	.tx_empty	=	sunzilog_tx_empty,
>  	.set_mctrl	=	sunzilog_set_mctrl,
> @@ -1013,6 +1061,10 @@ static struct uart_ops sunzilog_pops = {
>  	.request_port	=	sunzilog_request_port,
>  	.config_port	=	sunzilog_config_port,
>  	.verify_port	=	sunzilog_verify_port,
> +#ifdef CONFIG_CONSOLE_POLL
> +	.poll_get_char	= sunzilog_get_poll_char,
> +	.poll_put_char	= sunzilog_put_poll_char,
> +#endif
>  };

Please make the indentation consistent with the rest of those in
this structure.
