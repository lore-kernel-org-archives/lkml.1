Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZBBXoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZBBXoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbZBBXno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:43:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758233AbZBBXnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:43:43 -0500
Date: Mon, 2 Feb 2009 15:43:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Larson <pl@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Scott.Kilau@digi.com, stable@kernel.org
Subject: Re: [PATCH 1/1] Add enable_ms to jsm driver
Message-Id: <20090202154301.b4be1815.akpm@linux-foundation.org>
In-Reply-To: <1233332509.8792.4.camel@plap>
References: <1233332509.8792.4.camel@plap>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009 10:21:49 -0600
Paul Larson <pl@linux.vnet.ibm.com> wrote:

> 
> This fixes a crash observed when non-existant enable_ms function is
> called for jsm driver.
> 
> Signed-off-by: Scott Kilau <Scott.Kilau@digi.com>
> Signed-off-by: Paul Larson <pl@linux.vnet.ibm.com>
> ---
>  drivers/serial/jsm/jsm_tty.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
> index 3547558..324c74d 100644
> --- a/drivers/serial/jsm/jsm_tty.c
> +++ b/drivers/serial/jsm/jsm_tty.c
> @@ -161,6 +161,11 @@ static void jsm_tty_stop_rx(struct uart_port *port)
>  	channel->ch_bd->bd_ops->disable_receiver(channel);
>  }
>  
> +static void jsm_tty_enable_ms(struct uart_port *port)
> +{
> +	/* Nothing needed */
> +}
> +
>  static void jsm_tty_break(struct uart_port *port, int break_state)
>  {
>  	unsigned long lock_flags;
> @@ -345,6 +350,7 @@ static struct uart_ops jsm_ops = {
>  	.start_tx	= jsm_tty_start_tx,
>  	.send_xchar	= jsm_tty_send_xchar,
>  	.stop_rx	= jsm_tty_stop_rx,
> +	.enable_ms	= jsm_tty_enable_ms,
>  	.break_ctl	= jsm_tty_break,
>  	.startup	= jsm_tty_open,
>  	.shutdown	= jsm_tty_close,

This patch is now in mainline for 2.6.29, as
0461ec5bc7745b89a8ab67ba0ea497abd58a6301.

It appears to be needed in every 2.6.x kernel back to at least 2.6.25,
but nobody told the -stable maintainers about this.

An appropriate way of flagging this is to add

Cc: <stable@kernel.org>

to the changelog body.
