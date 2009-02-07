Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZBGXGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZBGXGT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 18:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZBGXGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 18:06:09 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:11656 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZBGXGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 18:06:07 -0500
Date: Sun, 8 Feb 2009 00:05:53 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Frank Seidel <fseidel@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       ben-linux@fluff.org, linux-i2c@vger.kernel.org,
       Frank Seidel <fseidel@suse.de>, frank@f-seidel.de,
       w.sang@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] i2c: add missing KERN_* constants to printks
Message-ID: <20090208000553.059a0732@hyperion.delvare>
In-Reply-To: <498C3EEA.5060508@suse.de>
References: <498C3EEA.5060508@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

On Fri, 06 Feb 2009 14:45:14 +0100, Frank Seidel wrote:
> From: Frank Seidel <frank@f-seidel.de>
> 
> According to kerneljanitors todo list all printk calls (beginning
> a new line) should have an according KERN_* constant.
> Those are the missing pieces here for the i2c subsystem.
> 
> Signed-off-by: Frank Seidel <frank@f-seidel.de>
> ---
>  drivers/i2c/algos/i2c-algo-pca.c  |   34 ++++++++++++++++++----------------
>  drivers/i2c/algos/i2c-algo-pcf.c  |    2 +-
>  drivers/i2c/busses/i2c-pca-isa.c  |    5 +++--
>  drivers/i2c/busses/i2c-powermac.c |    3 ++-
>  drivers/i2c/busses/i2c-pxa.c      |    6 +++---
>  5 files changed, 27 insertions(+), 23 deletions(-)
> 
> --- a/drivers/i2c/busses/i2c-pca-isa.c
> +++ b/drivers/i2c/busses/i2c-pca-isa.c
> @@ -49,7 +49,8 @@ static void pca_isa_writebyte(void *pd,
>  {
>  #ifdef DEBUG_IO
>  	static char *names[] = { "T/O", "DAT", "ADR", "CON" };
> -	printk("*** write %s at %#lx <= %#04x\n", names[reg], base+reg, val);
> +	printk(KERN_DEBUG "*** write %s at %#lx <= %#04x\n", names[reg],
> +	       base+reg, val);
>  #endif
>  	outb(val, base+reg);
>  }
> @@ -60,7 +61,7 @@ static int pca_isa_readbyte(void *pd, in
>  #ifdef DEBUG_IO
>  	{
>  		static char *names[] = { "STA", "DAT", "ADR", "CON" };
> -		printk("*** read  %s => %#04x\n", names[reg], res);
> +		printk(KERN_DEBUG "*** read  %s => %#04x\n", names[reg], res);
>  	}
>  #endif
>  	return res;
> --- a/drivers/i2c/busses/i2c-pxa.c
> +++ b/drivers/i2c/busses/i2c-pxa.c
> @@ -210,10 +210,10 @@ static irqreturn_t i2c_pxa_handler(int t
>  static void i2c_pxa_scream_blue_murder(struct pxa_i2c *i2c, const char *why)
>  {
>  	unsigned int i;
> -	printk("i2c: error: %s\n", why);
> -	printk("i2c: msg_num: %d msg_idx: %d msg_ptr: %d\n",
> +	printk(KERN_ERR "i2c: error: %s\n", why);
> +	printk(KERN_ERR "i2c: msg_num: %d msg_idx: %d msg_ptr: %d\n",
>  		i2c->msg_num, i2c->msg_idx, i2c->msg_ptr);
> -	printk("i2c: ICR: %08x ISR: %08x\n"
> +	printk(KERN_ERR "i2c: ICR: %08x ISR: %08x\n"
>  	       "i2c: log: ", readl(_ICR(i2c)), readl(_ISR(i2c)));
>  	for (i = 0; i < i2c->irqlogidx; i++)
>  		printk("[%08x:%08x] ", i2c->isrlog[i], i2c->icrlog[i]);

This last printk also lacks a log level. You can't add it in the loop,
but you could add one printk before the loop, printing just the log level.

> --- a/drivers/i2c/busses/i2c-powermac.c
> +++ b/drivers/i2c/busses/i2c-powermac.c
> @@ -191,7 +191,8 @@ static int __devexit i2c_powermac_remove
>  	i2c_set_adapdata(adapter, NULL);
>  	/* We aren't that prepared to deal with this... */
>  	if (rc)
> -		printk("i2c-powermac.c: Failed to remove bus %s !\n",
> +		printk(KERN_WARNING
> +		       "i2c-powermac.c: Failed to remove bus %s !\n",
>  		       adapter->name);
>  	platform_set_drvdata(dev, NULL);
>  	kfree(adapter);
> --- a/drivers/i2c/algos/i2c-algo-pca.c
> +++ b/drivers/i2c/algos/i2c-algo-pca.c
> @@ -51,7 +51,7 @@ static int i2c_debug;
>  static void pca_start(struct i2c_algo_pca_data *adap)
>  {
>  	int sta = pca_get_con(adap);
> -	DEB2("=== START\n");
> +	DEB2(KERN_WARNING "=== START\n");
>  	sta |= I2C_PCA_CON_STA;
>  	sta &= ~(I2C_PCA_CON_STO|I2C_PCA_CON_SI);
>  	pca_set_con(adap, sta);
> @@ -66,7 +66,7 @@ static void pca_start(struct i2c_algo_pc
>  static void pca_repeated_start(struct i2c_algo_pca_data *adap)
>  {
>  	int sta = pca_get_con(adap);
> -	DEB2("=== REPEATED START\n");
> +	DEB2(KERN_WARNING "=== REPEATED START\n");
>  	sta |= I2C_PCA_CON_STA;
>  	sta &= ~(I2C_PCA_CON_STO|I2C_PCA_CON_SI);
>  	pca_set_con(adap, sta);
> @@ -85,7 +85,7 @@ static void pca_repeated_start(struct i2
>  static void pca_stop(struct i2c_algo_pca_data *adap)
>  {
>  	int sta = pca_get_con(adap);
> -	DEB2("=== STOP\n");
> +	DEB2(KERN_WARNING "=== STOP\n");
>  	sta |= I2C_PCA_CON_STO;
>  	sta &= ~(I2C_PCA_CON_STA|I2C_PCA_CON_SI);
>  	pca_set_con(adap, sta);
> @@ -105,7 +105,7 @@ static void pca_address(struct i2c_algo_
>  	addr = ( (0x7f & msg->addr) << 1 );
>  	if (msg->flags & I2C_M_RD )
>  		addr |= 1;
> -	DEB2("=== SLAVE ADDRESS %#04x+%c=%#04x\n",
> +	DEB2(KERN_WARNING "=== SLAVE ADDRESS %#04x+%c=%#04x\n",
>  	     msg->addr, msg->flags & I2C_M_RD ? 'R' : 'W', addr);
>  
>  	pca_outw(adap, I2C_PCA_DAT, addr);
> @@ -125,7 +125,7 @@ static void pca_tx_byte(struct i2c_algo_
>  			__u8 b)
>  {
>  	int sta = pca_get_con(adap);
> -	DEB2("=== WRITE %#04x\n", b);
> +	DEB2(KERN_WARNING "=== WRITE %#04x\n", b);
>  	pca_outw(adap, I2C_PCA_DAT, b);
>  
>  	sta &= ~(I2C_PCA_CON_STO|I2C_PCA_CON_STA|I2C_PCA_CON_SI);
> @@ -143,7 +143,7 @@ static void pca_rx_byte(struct i2c_algo_
>  			__u8 *b, int ack)
>  {
>  	*b = pca_inw(adap, I2C_PCA_DAT);
> -	DEB2("=== READ %#04x %s\n", *b, ack ? "ACK" : "NACK");
> +	DEB2(KERN_WARNING "=== READ %#04x %s\n", *b, ack ? "ACK" : "NACK");
>  }
>  
>  /*
> @@ -185,7 +185,7 @@ static int pca_xfer(struct i2c_adapter *
>  		return -EAGAIN;
>  	}
>  
> -	DEB1("{{{ XFER %d messages\n", num);
> +	DEB1(KERN_WARNING "{{{ XFER %d messages\n", num);
>  
>  	if (i2c_debug>=2) {
>  		for (curmsg = 0; curmsg < num; curmsg++) {
> @@ -213,7 +213,7 @@ static int pca_xfer(struct i2c_adapter *
>  	while (curmsg < num) {
>  		state = pca_status(adap);
>  
> -		DEB3("STATE is 0x%02x\n", state);
> +		DEB3(KERN_WARNING "STATE is 0x%02x\n", state);
>  		msg = &msgs[curmsg];
>  
>  		switch (state) {
> @@ -241,7 +241,7 @@ static int pca_xfer(struct i2c_adapter *
>  			break;
>  
>  		case 0x20: /* SLA+W has been transmitted; NOT ACK has been received */
> -			DEB2("NOT ACK received after SLA+W\n");
> +			DEB2(KERN_WARNING "NOT ACK received after SLA+W\n");
>  			pca_stop(adap);
>  			goto out;
>  
> @@ -264,16 +264,16 @@ static int pca_xfer(struct i2c_adapter *
>  			break;
>  
>  		case 0x48: /* SLA+R has been transmitted; NOT ACK has been received */
> -			DEB2("NOT ACK received after SLA+R\n");
> +			DEB2(KERN_WARNING "NOT ACK received after SLA+R\n");
>  			pca_stop(adap);
>  			goto out;
>  
>  		case 0x30: /* Data byte in I2CDAT has been transmitted; NOT ACK has been received */
> -			DEB2("NOT ACK received after data byte\n");
> +			DEB2(KERN_WARNING "NOT ACK received after data byte\n");
>  			goto out;
>  
>  		case 0x38: /* Arbitration lost during SLA+W, SLA+R or data bytes */
> -			DEB2("Arbitration lost\n");
> +			DEB2(KERN_WARNING "Arbitration lost\n");
>  			goto out;
>  
>  		case 0x58: /* Data byte has been received; NOT ACK has been returned */
> @@ -285,7 +285,8 @@ static int pca_xfer(struct i2c_adapter *
>  				else
>  					pca_repeated_start(adap);
>  			} else {
> -				DEB2("NOT ACK sent after data byte received. "
> +				DEB2(KERN_WARNING
> +				     "NOT ACK sent after data byte received. "
>  				     "Not final byte. numbytes %d. len %d\n",
>  				     numbytes, msg->len);
>  				pca_stop(adap);
> @@ -293,15 +294,16 @@ static int pca_xfer(struct i2c_adapter *
>  			}
>  			break;
>  		case 0x70: /* Bus error - SDA stuck low */
> -			DEB2("BUS ERROR - SDA Stuck low\n");
> +			DEB2(KERN_WARNING "BUS ERROR - SDA Stuck low\n");
>  			pca_reset(adap);
>  			goto out;
>  		case 0x90: /* Bus error - SCL stuck low */
> -			DEB2("BUS ERROR - SCL Stuck low\n");
> +			DEB2(KERN_WARNING "BUS ERROR - SCL Stuck low\n");
>  			pca_reset(adap);
>  			goto out;
>  		case 0x00: /* Bus error during master or slave mode due to illegal START or STOP condition */
> -			DEB2("BUS ERROR - Illegal START or STOP\n");
> +			DEB2(KERN_WARNING
> +			     "BUS ERROR - Illegal START or STOP\n");
>  			pca_reset(adap);
>  			goto out;
>  		default:

I second Uwe's comments: it would be much better to add the log level
in the DEBx macros. Additionally, some discussion is needed as to what
log level would be appropriate. You put KERN_WARNING for all but some
of these messages are clearly debugging messages. As a matter of fact,
DEBx macros are all about debugging.

So I think that a good patch would 1* add KERN_DEBUG to the DEBx macros
and 2* check for all usage of these DEBx macros and turn all messages
which aren't actual debug messages to raw printks. As this will require
some more work, you may want to split these changes off your initial
patch.

> --- a/drivers/i2c/algos/i2c-algo-pcf.c
> +++ b/drivers/i2c/algos/i2c-algo-pcf.c
> @@ -61,7 +61,7 @@ static int i2c_debug;
>  
>  static void i2c_start(struct i2c_algo_pcf_data *adap) 
>  {
> -	DEBPROTO(printk("S "));
> +	DEBPROTO(printk(KERN_WARNING "S "));
>  	set_pcf(adap, 1, I2C_PCF_START);
>  }

This one is a clear KERN_DEBUG.

-- 
Jean Delvare
