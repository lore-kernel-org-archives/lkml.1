Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbZIVWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbZIVWKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 18:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZIVWK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 18:10:29 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:22924 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbZIVWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 18:10:29 -0400
Date: Tue, 22 Sep 2009 15:09:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: fix htmldocs warnings
Message-Id: <20090922150915.8bcc203d.randy.dunlap@oracle.com>
In-Reply-To: <1253657038.3187.1.camel@ht.satnam>
References: <1253657038.3187.1.camel@ht.satnam>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt015.oracle.com [141.146.116.24]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AB94B0D.015F:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 03:33:58 +0530 Jaswinder Singh Rajput wrote:

> 
>  Warning(/home/jaswinder/linux-2.6//include/linux/serial_core.h:485): No description found for parameter 'uport'
>  Warning(/home/jaswinder/linux-2.6//include/linux/serial_core.h:485): Excess function parameter 'port' description in 'uart_handle_dcd_change'
>  Warning(/home/jaswinder/linux-2.6//include/linux/serial_core.h:511): No description found for parameter 'uport'
>  Warning(/home/jaswinder/linux-2.6//include/linux/serial_core.h:511): Excess function parameter 'port' description in 'uart_handle_cts_change'
>  Warning(/home/jaswinder/linux-2.6//drivers/serial/serial_core.c:2437): No description found for parameter 'uport'
>  Warning(/home/jaswinder/linux-2.6//drivers/serial/serial_core.c:2437): Excess function parameter 'port' description in 'uart_add_one_port'
>  Warning(/home/jaswinder/linux-2.6//drivers/serial/serial_core.c:2509): No description found for parameter 'uport'
>  Warning(/home/jaswinder/linux-2.6//drivers/serial/serial_core.c:2509): Excess function parameter 'port' description in 'uart_remove_one_port'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Ack.  I've already sent the same patch.

> ---
>  drivers/serial/serial_core.c |    4 ++--
>  include/linux/serial_core.h  |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
> index 2514d00..1689bda 100644
> --- a/drivers/serial/serial_core.c
> +++ b/drivers/serial/serial_core.c
> @@ -2426,7 +2426,7 @@ struct tty_driver *uart_console_device(struct console *co, int *index)
>  /**
>   *	uart_add_one_port - attach a driver-defined port structure
>   *	@drv: pointer to the uart low level driver structure for this port
> - *	@port: uart port structure to use for this port.
> + *	@uport: uart port structure to use for this port.
>   *
>   *	This allows the driver to register its own uart_port structure
>   *	with the core driver.  The main purpose is to allow the low
> @@ -2499,7 +2499,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
>  /**
>   *	uart_remove_one_port - detach a driver defined port structure
>   *	@drv: pointer to the uart low level driver structure for this port
> - *	@port: uart port structure for this port
> + *	@uport: uart port structure for this port
>   *
>   *	This unhooks (and hangs up) the specified port structure from the
>   *	core driver.  No further calls will be made to the low-level code
> diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
> index d58e460..fe661af 100644
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -477,7 +477,7 @@ static inline int uart_handle_break(struct uart_port *port)
>  
>  /**
>   *	uart_handle_dcd_change - handle a change of carrier detect state
> - *	@port: uart_port structure for the open port
> + *	@uport: uart_port structure for the open port
>   *	@status: new carrier detect status, nonzero if active
>   */
>  static inline void
> @@ -503,7 +503,7 @@ uart_handle_dcd_change(struct uart_port *uport, unsigned int status)
>  
>  /**
>   *	uart_handle_cts_change - handle a change of clear-to-send state
> - *	@port: uart_port structure for the open port
> + *	@uport: uart_port structure for the open port
>   *	@status: new clear to send status, nonzero if active
>   */
>  static inline void
> -- 
> 1.6.0.6
> 
> 


---
~Randy
