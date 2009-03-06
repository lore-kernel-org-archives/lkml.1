Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZCFWmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZCFWmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbZCFWlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:41:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757799AbZCFWlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:41:31 -0500
Date: Fri, 6 Mar 2009 14:38:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       sonic.zhang@analog.com, cooloney@kernel.org
Subject: Re: [PATCH 03/18] Blackfin Serial Driver: fix a in dma circle rx
 buffer handling
Message-Id: <20090306143800.107e668a.akpm@linux-foundation.org>
In-Reply-To: <1236321780-28718-4-git-send-email-cooloney@kernel.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	<1236321780-28718-4-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  6 Mar 2009 14:42:45 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> Subject: [PATCH 03/18] Blackfin Serial Driver: fix a in dma circle rx buffer handling

I changed this to "fix a bug"

> Date: 	Fri,  6 Mar 2009 14:42:45 +0800
> Sender: linux-kernel-owner@vger.kernel.org
> X-Mailer: git-send-email 1.5.6.3
> 
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Reported-by: Qian Zhang <zhangq@sansitech.com>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

No changelog.

>  drivers/serial/bfin_5xx.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> index 350bfc4..1e027e3 100644
> --- a/drivers/serial/bfin_5xx.c
> +++ b/drivers/serial/bfin_5xx.c
> @@ -402,9 +402,11 @@ static void bfin_serial_dma_rx_chars(struct bfin_serial_port *uart)
>  	else
>  		flg = TTY_NORMAL;
>  
> -	for (i = uart->rx_dma_buf.tail; i != uart->rx_dma_buf.head; i++) {
> +	for (i = uart->rx_dma_buf.tail; ; i++) {
>  		if (i >= UART_XMIT_SIZE)
>  			i = 0;
> +		if (i == uart->rx_dma_buf.head)
> +			break;
>  		if (!uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
>  			uart_insert_char(&uart->port, status, OE,
>  				uart->rx_dma_buf.buf[i], flg);

The fix is not sufficiently obvious to justify the omission of a
changelog.

Please always include a changelog unless the patch is quite obvious.

Please send a changelog entry for this patch.  This one should contain
a description of the bug and a description of how it was fixed.  A
bugfix's changelog should also provide the reviewer with an
understanding of the seriousness of the bug - what impact does it have
upon users?  Because without this information we cannot decide into
which kernel version(s) the code should be merged.

It is alse very useful if the maintainer and/or patch submitter provide
information about which kernel versions are affected and whether the
fix should be backported into -stable kerenls and if so, why.


Bryan, I should not need to explain all this stuff to you.  Please
don't let this happen again.

