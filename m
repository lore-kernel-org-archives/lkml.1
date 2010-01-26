Return-Path: <linux-kernel-owner+w=401wt.eu-S1751342Ab0AZALc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab0AZALc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846Ab0AZALb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:11:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750833Ab0AZALa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:11:30 -0500
Date: Mon, 25 Jan 2010 16:11:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 3/4] serial: bfin_5xx: kgdboc should accept gdb break
 only when it is active
Message-Id: <20100125161120.74cea0d4.akpm@linux-foundation.org>
In-Reply-To: <1263899593-12178-3-git-send-email-vapier@gentoo.org>
References: <1263899593-12178-1-git-send-email-vapier@gentoo.org>
	<1263899593-12178-3-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 06:13:12 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> If we always check for gdb breaks even when it isn't active, we get false
> positives on normal code and the system panics.
> 
> URL: http://blackfin.uclinux.org/gf/tracker/5277
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  drivers/serial/bfin_5xx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index b5a9b37..6b87955 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -237,7 +237,8 @@ static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
>  
>  #if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
>  	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
> -	if (kgdb_connected && kgdboc_port_line == uart->port.line)
> +	if (kgdb_connected && kgdboc_port_line == uart->port.line
> +		&& kgdboc_break_enabled)
>  		if (ch == 0x3) {/* Ctrl + C */
>  			kgdb_breakpoint();
>  			return;

I expect that we want

	[PATCH 2/4] serial: bfin_5xx: need to disable DMA TX interrupt too
and
	[PATCH 3/4] serial: bfin_5xx: kgdboc should accept gdb break only when it is active

in 2.6.33 and the other two in 2.6.34?

If so then should either of the above two also be backported into
-stable?

