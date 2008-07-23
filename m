Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbYGWWsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbYGWWsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 18:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYGWWsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 18:48:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:39081 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414AbYGWWsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 18:48:31 -0400
Date: Wed, 23 Jul 2008 15:45:33 -0700
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console v2
Message-ID: <20080723224533.GA29234@kroah.com>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807231400.53957.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2008 at 02:00:53PM -0700, Yinghai Lu wrote:
> --- linux-2.6.orig/drivers/usb/host/ehci.h
> +++ linux-2.6/drivers/usb/host/ehci.h
> @@ -62,6 +62,7 @@ struct ehci_stats {
>  
>  #define	EHCI_MAX_ROOT_PORTS	15		/* see HCS_N_PORTS */
>  
> +#ifndef EARLY_PRINTK
>  struct ehci_hcd {			/* one per controller */
>  	/* glue to PCI and HCD framework */
>  	struct ehci_caps __iomem *caps;
> @@ -207,6 +208,7 @@ timer_action (struct ehci_hcd *ehci, enu
>  		mod_timer(&ehci->watchdog, t + jiffies);
>  	}
>  }
> +#endif /* EARLY_PRINTK */
>  
>  /*-------------------------------------------------------------------------*/
>  
> @@ -352,6 +354,8 @@ struct ehci_dbg_port {
>  
>  #define	QTD_NEXT(ehci, dma)	cpu_to_hc32(ehci, (u32)dma)
>  
> +#ifndef EARLY_PRINTK
> +
>  /*
>   * EHCI Specification 0.95 Section 3.5
>   * QTD: describe data transfer components (buffer, direction, ...)
> @@ -392,7 +396,7 @@ struct ehci_qtd {
>  	struct urb		*urb;			/* qtd's urb */
>  	size_t			length;			/* length of buffer */
>  } __attribute__ ((aligned (32)));
> -
> +#endif
>  /* mask NakCnt+T in qh->hw_alt_next */
>  #define QTD_MASK(ehci)	cpu_to_hc32 (ehci, ~0x1f)
>  
> @@ -449,6 +453,7 @@ union ehci_shadow {
>   * These appear in both the async and (for interrupt) periodic schedules.
>   */
>  
> +#ifndef EARLY_PRINTK
>  struct ehci_qh {
>  	/* first part defined by EHCI spec */
>  	__hc32			hw_next;	/* see EHCI 3.6.1 */
> @@ -504,6 +509,7 @@ struct ehci_qh {
>  #define NO_FRAME ((unsigned short)~0)			/* pick new start */
>  	struct usb_device	*dev;		/* access to TT */
>  } __attribute__ ((aligned (32)));
> +#endif /* EARLY_PRITNK */
>  
>  /*-------------------------------------------------------------------------*/
>  
> @@ -517,6 +523,7 @@ struct ehci_iso_packet {
>  	u32			buf1;
>  };
>  
> +#ifndef EARLY_PRINTK
>  /* temporary schedule data for packets from iso urbs (both speeds)
>   * each packet is one logical usb transaction to the device (not TT),
>   * beginning at stream->next_uframe
> @@ -651,6 +658,7 @@ struct ehci_sitd {
>  	unsigned		frame;
>  	unsigned		index;
>  } __attribute__ ((aligned (32)));
> +#endif
>  
>  /*-------------------------------------------------------------------------*/
>  
> @@ -672,6 +680,8 @@ struct ehci_fstn {
>  	union ehci_shadow	fstn_next;	/* ptr to periodic q entry */
>  } __attribute__ ((aligned (32)));
>  
> +#ifndef EARLY_PRINTK
> +
>  /*-------------------------------------------------------------------------*/
>  
>  #ifdef CONFIG_USB_EHCI_ROOT_HUB_TT
> @@ -843,4 +853,6 @@ static inline u32 hc32_to_cpup (const st
>  
>  /*-------------------------------------------------------------------------*/
>  
> +#endif /* EARLY_PRINTK */
> +
>  #endif /* __LINUX_EHCI_HCD_H */

I don't understand the issue of any of these #ifdefs here.  Why are they
needed?

And shouldn't there be a separate config option for early printk through
the ehci debug port?

thanks,

greg k-h
