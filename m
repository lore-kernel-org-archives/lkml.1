Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbXKESN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbXKESN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXKESNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:13:18 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:58474 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbXKESNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:13:17 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2007 13:13:17 EST
Date: Mon, 05 Nov 2007 12:43:10 -0500
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: [v4l-dvb-maintainer] [2.6 patch] media/video/cx23885/: cleanups
In-reply-to: <20071105170720.GL12045@stusta.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Steven Toth <stoth@hauppauge.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Message-id: <472F562E.5030505@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <20071105170720.GL12045@stusta.de>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the following cleanups:
> - make the following needlessly global code static:
>   - cx23885-core.c: struct cx23885_sram_channels[]
>   - cx23885-core.c: struct cx23887_sram_channels[]
>   - cx23885-core.c: cx23885_wakeup()
>   - cx23885-core.c: cx23885_sram_channel_setup()
>   - cx23885-core.c: cx23885_sram_channel_dump()
>   - cx23885-core.c: cx23885_risc_disasm()
>   - cx23885-core.c: cx23885_shutdown()
>   - cx23885-core.c: cx23885_reset()
>   - cx23885-core.c: cx23885_dev_unregister()
>   - cx23885-core.c: cx23885_risc_databuffer()
>   - cx23885-core.c: cx23885_risc_stopper()
> - #if 0 the following unused functions:
>   - cx23885-core.c: cx23885_risc_buffer()
>   - cx23885-core.c: cx23885_cancel_buffers()
> - remove the following unused EXPORT_SYMBOL's:
>   - cx23885-cards.c: cx23885_boards
>   - cx23885-i2c.c: cx23885_call_i2c_clients
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/media/video/cx23885/cx23885-cards.c |    2 
>  drivers/media/video/cx23885/cx23885-core.c  |   50 ++++++++++----------
>  drivers/media/video/cx23885/cx23885-i2c.c   |    2 
>  drivers/media/video/cx23885/cx23885.h       |    4 -
>  4 files changed, 27 insertions(+), 31 deletions(-)
> 
> 23f11be19ad99d0c560955ddf96a3a3bace80721 
> diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
> index b9012ac..134b931 100644
> --- a/drivers/media/video/cx23885/cx23885-cards.c
> +++ b/drivers/media/video/cx23885/cx23885-cards.c
> @@ -270,8 +270,6 @@ void cx23885_card_setup(struct cx23885_dev *dev)
>  
>  /* ------------------------------------------------------------------ */
>  
> -EXPORT_SYMBOL(cx23885_boards);
> -
>  /*
>   * Local variables:
>   * c-basic-offset: 8
> diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
> index 3cdd136..0248bf5 100644
> --- a/drivers/media/video/cx23885/cx23885-core.c
> +++ b/drivers/media/video/cx23885/cx23885-core.c
> @@ -73,7 +73,7 @@ static LIST_HEAD(cx23885_devlist);
>   * 0x00010ea0 0x00010xxx Free
>   */
>  
> -struct sram_channel cx23885_sram_channels[] = {
> +static struct sram_channel cx23885_sram_channels[] = {
>  	[SRAM_CH01] = {
>  		.name		= "test ch1",
>  		.cmds_start	= 0x10000,
> @@ -205,7 +205,7 @@ struct sram_channel cx23885_sram_channels[] = {
>   * 0x00010ea0 0x00010xxx Free
>   */
>  
> -struct sram_channel cx23887_sram_channels[] = {
> +static struct sram_channel cx23887_sram_channels[] = {
>  	[SRAM_CH01] = {
>  		.name		= "test ch1",
>  		.cmds_start	= 0x0,
> @@ -356,8 +356,8 @@ static int cx23885_risc_decode(u32 risc)
>  	return incr[risc >> 28] ? incr[risc >> 28] : 1;
>  }
>  
> -void cx23885_wakeup(struct cx23885_tsport *port,
> -		    struct cx23885_dmaqueue *q, u32 count)
> +static void cx23885_wakeup(struct cx23885_tsport *port,
> +			   struct cx23885_dmaqueue *q, u32 count)
>  {
>  	struct cx23885_dev *dev = port->dev;
>  	struct cx23885_buffer *buf;
> @@ -391,12 +391,10 @@ void cx23885_wakeup(struct cx23885_tsport *port,
>  		printk("%s: %d buffers handled (should be 1)\n",
>  		       __FUNCTION__, bc);
>  }
> -void cx23885_sram_channel_dump(struct cx23885_dev *dev,
> -			       struct sram_channel *ch);
>  
> -int cx23885_sram_channel_setup(struct cx23885_dev *dev,
> -			       struct sram_channel *ch,
> -			       unsigned int bpl, u32 risc)
> +static int cx23885_sram_channel_setup(struct cx23885_dev *dev,
> +				      struct sram_channel *ch,
> +				      unsigned int bpl, u32 risc)
>  {
>  	unsigned int i, lines;
>  	u32 cdt;
> @@ -467,8 +465,8 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
>  	return 0;
>  }
>  
> -void cx23885_sram_channel_dump(struct cx23885_dev *dev,
> -			       struct sram_channel *ch)
> +static void cx23885_sram_channel_dump(struct cx23885_dev *dev,
> +				      struct sram_channel *ch)
>  {
>  	static char *name[] = {
>  		"init risc lo",
> @@ -529,8 +527,8 @@ void cx23885_sram_channel_dump(struct cx23885_dev *dev,
>  	       dev->name, cx_read(ch->cnt2_reg));
>  }
>  
> -void cx23885_risc_disasm(struct cx23885_tsport *port,
> -			 struct btcx_riscmem *risc)
> +static void cx23885_risc_disasm(struct cx23885_tsport *port,
> +				struct btcx_riscmem *risc)
>  {
>  	struct cx23885_dev *dev = port->dev;
>  	unsigned int i, j, n;
> @@ -548,7 +546,7 @@ void cx23885_risc_disasm(struct cx23885_tsport *port,
>  	}
>  }
>  
> -void cx23885_shutdown(struct cx23885_dev *dev)
> +static void cx23885_shutdown(struct cx23885_dev *dev)
>  {
>  	/* disable RISC controller */
>  	cx_write(DEV_CNTRL2, 0);
> @@ -578,7 +576,7 @@ void cx23885_shutdown(struct cx23885_dev *dev)
>  
>  }
>  
> -void cx23885_reset(struct cx23885_dev *dev)
> +static void cx23885_reset(struct cx23885_dev *dev)
>  {
>  	dprintk(1, "%s()\n", __FUNCTION__);
>  
> @@ -636,8 +634,8 @@ static int get_resources(struct cx23885_dev *dev)
>  }
>  
>  static void cx23885_timeout(unsigned long data);
> -int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> -			 u32 reg, u32 mask, u32 value);
> +static int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> +				u32 reg, u32 mask, u32 value);
>  
>  static int cx23885_init_tsport(struct cx23885_dev *dev, struct cx23885_tsport *port, int portno)
>  {
> @@ -837,7 +835,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
>  	return 0;
>  }
>  
> -void cx23885_dev_unregister(struct cx23885_dev *dev)
> +static void cx23885_dev_unregister(struct cx23885_dev *dev)
>  {
>  	release_mem_region(pci_resource_start(dev->pci,0),
>  			   pci_resource_len(dev->pci,0));
> @@ -912,6 +910,7 @@ static u32* cx23885_risc_field(u32 *rp, struct scatterlist *sglist,
>  	return rp;
>  }
>  
> +#if 0
>  int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  			struct scatterlist *sglist, unsigned int top_offset,
>  			unsigned int bottom_offset, unsigned int bpl,
> @@ -951,10 +950,13 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof (*risc->cpu) > risc->size);
>  	return 0;
>  }
> +#endif  /*  0  */
>  
> -int cx23885_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
> -			    struct scatterlist *sglist, unsigned int bpl,
> -			    unsigned int lines)
> +static int cx23885_risc_databuffer(struct pci_dev *pci,
> +				   struct btcx_riscmem *risc,
> +				   struct scatterlist *sglist,
> +				   unsigned int bpl,
> +				   unsigned int lines)
>  {
>  	u32 instructions;
>  	u32 *rp;
> @@ -981,8 +983,8 @@ int cx23885_risc_databuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	return 0;
>  }
>  
> -int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> -			 u32 reg, u32 mask, u32 value)
> +static int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> +				u32 reg, u32 mask, u32 value)
>  {
>  	u32 *rp;
>  	int rc;
> @@ -1243,6 +1245,7 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason,
>  	spin_unlock_irqrestore(&port->slock, flags);
>  }
>  
> +#if 0
>  void cx23885_cancel_buffers(struct cx23885_tsport *port)
>  {
>  	struct cx23885_dev *dev = port->dev;
> @@ -1253,6 +1256,7 @@ void cx23885_cancel_buffers(struct cx23885_tsport *port)
>  	cx23885_stop_dma(port);
>  	do_cancel_buffers(port, "cancel", 0);
>  }
> +#endif  /*  0  */
>  
>  static void cx23885_timeout(unsigned long data)
>  {
> diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
> index 71da528..12c3006 100644
> --- a/drivers/media/video/cx23885/cx23885-i2c.c
> +++ b/drivers/media/video/cx23885/cx23885-i2c.c
> @@ -366,8 +366,6 @@ int cx23885_i2c_unregister(struct cx23885_i2c *bus)
>  
>  /* ----------------------------------------------------------------------- */
>  
> -EXPORT_SYMBOL(cx23885_call_i2c_clients);
> -
>  /*
>   * Local variables:
>   * c-basic-offset: 8
> diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
> index dec4dc2..205640c 100644
> --- a/drivers/media/video/cx23885/cx23885.h
> +++ b/drivers/media/video/cx23885/cx23885.h
> @@ -254,10 +254,6 @@ struct sram_channel {
>  #define cx_set(reg,bit)          cx_andor((reg),(bit),(bit))
>  #define cx_clear(reg,bit)        cx_andor((reg),(bit),0)
>  
> -extern int cx23885_sram_channel_setup(struct cx23885_dev *dev,
> -	struct sram_channel *ch,
> -	unsigned int bpl, u32 risc);
> -
>  /* ----------------------------------------------------------- */
>  /* cx23885-cards.c                                                */
>  
> 
> 
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer

Thanks Adrian.

Signed-off-by: Steven Toth (stoth@linuxtv.org)

