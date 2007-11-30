Return-Path: <linux-kernel-owner+w=401wt.eu-S934032AbXK3NMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbXK3NMT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbXK3NMB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:12:01 -0500
Received: from styx.suse.cz ([82.119.242.94]:36283 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754098AbXK3NMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:12:00 -0500
Message-ID: <47500C1F.7080803@suse.cz>
Date: Fri, 30 Nov 2007 14:11:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dsterba@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       akpm@linux-foundation.org, jeff@garzik.org, jkosina@suse.cz,
       stephen@symmetric.co.nz, benm@symmetric.co.nz
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
References: <20071130125555.GA10977@ds.suse.cz>
In-Reply-To: <20071130125555.GA10977@ds.suse.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2007 01:55 PM, David Sterba wrote:
> Hi,
> 
> I'm submitting driver for IPWireless PC Card, used for 4G
> internet connection.
> The driver has been in -mm series as ipwireless_cs.git tree for
> some time, is actively used and there are currently no
> outstanding bugs.

Almost :).

[...]
> Rewieved-by: Jiri Slaby <jslaby@suse.cz>
[...]
> diff --git a/drivers/char/pcmcia/ipwireless_cs_hardware.c b/drivers/char/pcmcia/ipwireless_cs_hardware.c
> new file mode 100644
> index 0000000..d67ce2e
> --- /dev/null
> +++ b/drivers/char/pcmcia/ipwireless_cs_hardware.c
[...]
> +static struct ipw_rx_packet *pool_allocate(struct ipw_hardware *hw,
> +					   struct ipw_rx_packet *packet,
> +					   int minimum_free_space)
> +{
> +
> +	if (!packet) {
> +		unsigned long flags;
> +
> +		/*
> +		 * If this is the first fragment, then we will need to fetch a
> +		 * packet to put it in.
> +		 */
> +		spin_lock_irqsave(&hw->spinlock, flags);
> +		/* If we have one in our pool, then pull it out. */
> +		if (!list_empty(&hw->rx_pool)) {
> +			packet = list_first_entry(&hw->rx_pool,
> +					struct ipw_rx_packet, queue);
> +			list_del(&packet->queue);
> +			hw->rx_pool_size--;
> +			spin_unlock_irqrestore(&hw->spinlock, flags);
> +		} else {
> +			/* Otherwise allocate a new one. */
> +			static int min_capacity = 256;
> +			int new_capacity;
> +
> +			spin_unlock_irqrestore(&hw->spinlock, flags);
> +			new_capacity =
> +			    minimum_free_space > min_capacity
> +			    ? minimum_free_space
> +			    : min_capacity;
> +			packet = kmalloc(sizeof(struct ipw_rx_packet)
> +					+ new_capacity, GFP_ATOMIC);

These not-testing-alloc-retvals remain unresolved. Please post a -fix or patch
v2 if any other comments come.

> +			packet->capacity = new_capacity;
...

thanks.
