Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZELWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZELWIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZELWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:08:09 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:38145 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913AbZELWII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:08:08 -0400
Date: Wed, 13 May 2009 00:08:07 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Deepak Saxena <dsaxena@plexity.net>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] 8250: Don't restore NS16550 mode when console suspend
	is disabled
Message-ID: <20090512220807.GA26588@rere.qmqm.pl>
References: <20090512210015.GA25540@plexity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090512210015.GA25540@plexity.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:00:16PM +0000, Deepak Saxena wrote:
> Commit b5b82df6, from May 2007, breaks no_console_suspend on the OLPC 
> XO laptop. Basically what happens is that upon returning from resume, 
> serial8250_resume_port() will reconfigure the port for high speed
> mode and all console output will be garbled, making debug of the 
> resume path painful. This patch modifies serial8250_resume_port() to 
> not touch the port in the case where it is the console port and console 
> suspend is disabled.
[cut]
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2887,7 +2887,8 @@ void serial8250_resume_port(int line)
>  {
>  	struct uart_8250_port *up = &serial8250_ports[line];
>  
> -	if (up->capabilities & UART_NATSEMI) {
> +	if ((up->capabilities & UART_NATSEMI) && 
> +	     (!uart_console(&up->port) && console_suspend_enabled)) {

Shouldn't this be || instead of && - as in: if it is NOT a console port
OR console suspend is enabled?

Best Regards,
Micha³ Miros³aw

