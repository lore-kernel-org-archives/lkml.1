Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZCFWjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZCFWjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZCFWjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:39:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941AbZCFWjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:39:02 -0500
Date: Fri, 6 Mar 2009 14:38:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       vapier.adi@gmail.com, cooloney@kernel.org
Subject: Re: [PATCH 06/18] Blackfin Serial Driver: explain why we cannot
 cpu_relax() in early serial code
Message-Id: <20090306143816.ed70f0e1.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-7-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-7-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:48 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/serial/bfin_5xx.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index 5a163f6..de8709d 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -1190,6 +1190,10 @@ static __init void early_serial_putc(struct uart_port *port, int ch)
>  	unsigned timeout = 0xffff;
>  	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
>  
> +	/* We cannot cpu_relax() here as doing so on the BF561 relies
> +	 * on the per-cpu region being setup, and since this is early
> +	 * serial code, it may not yet be usable ...
> +	 */
>  	while ((!(UART_GET_LSR(uart) & THRE)) && --timeout)
>  		barrier();

Again: this is blackfin core breakage.
