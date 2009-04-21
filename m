Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZDUTt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZDUTt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZDUTts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:49:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbZDUTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:49:47 -0400
Date: Tue, 21 Apr 2009 12:47:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch] serial: add parameter to force skipping the test for
 the TXEN bug
Message-Id: <20090421124745.a641b1eb.akpm@linux-foundation.org>
In-Reply-To: <20090420180549.335552bb@dhcp-100-2-144.bos.redhat.com>
References: <20090420180549.335552bb@dhcp-100-2-144.bos.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 18:05:49 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> serial: add parameter to force skipping the test for the TXEN bug
> 
> Allow users to force skipping the TXEN test at init time. Applies
> to all serial ports. Intended for debugging only.
> 

<scratches head @ changelog>

> 
> Index: linux-2.6.29.noarch/drivers/serial/8250.c
> ===================================================================
> --- linux-2.6.29.noarch.orig/drivers/serial/8250.c
> +++ linux-2.6.29.noarch/drivers/serial/8250.c
> @@ -67,6 +67,8 @@ static int serial_index(struct uart_port
>  	return (serial8250_reg.minor - 64) + port->line;
>  }
>  
> +static unsigned int skip_txen_test; /* force skip of txen test at init time */
> +
>  /*
>   * Debugging.
>   */
> @@ -2097,7 +2099,7 @@ static int serial8250_startup(struct uar
>  	   is variable. So, let's just don't test if we receive
>  	   TX irq. This way, we'll never enable UART_BUG_TXEN.
>  	 */
> -	if (up->port.flags & UPF_NO_TXEN_TEST)
> +	if (skip_txen_test || up->port.flags & UPF_NO_TXEN_TEST)
>  		goto dont_test_tx_en;
>  
>  	/*
> @@ -3245,6 +3247,9 @@ MODULE_PARM_DESC(share_irqs, "Share IRQs
>  module_param(nr_uarts, uint, 0644);
>  MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
>  
> +module_param(skip_txen_test, uint, 0644);
> +MODULE_PARM_DESC(skip_txen_test, "Skip checking for the TXEN bug at init time");
> +
>  #ifdef CONFIG_SERIAL_8250_RSA
>  module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
>  MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");

Why is this useful?  What is the problem which you're solving here?
