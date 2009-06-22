Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977AbZFVEP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbZFVEP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 00:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbZFVEPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 00:15:50 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:41083 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbZFVEPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 00:15:50 -0400
Date: Mon, 22 Jun 2009 07:14:57 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
Message-ID: <20090622041457.GC6027@tarshish>
References: <4A3F017B.2010409@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3F017B.2010409@bluewatersys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

On Mon, Jun 22, 2009 at 03:58:51PM +1200, Ryan Mallon wrote:
> +static int sst25l_erase_block(struct sst25l_flash *flash, u32 offset)
> +{
> +	u8 command[4];
> +	int err;
> +
> +	err = sst25l_write_enable(flash, 1);

Is this enable/disable strictly required for each write/erase? Can't we just 
enable write once?

> +	if (err)
> +		return err;
> +
> +	command[0] = SST25L_CMD_BLOCK_ERASE;
> +	command[1] = offset >> 16;
> +	command[2] = offset >> 8;
> +	command[3] = offset;
> +	err = spi_write(flash->spi, command, 4);
> +	if (err)
> +		return err;
> +
> +	err = sst25l_wait_till_ready(flash);
> +	if (err)
> +		return err;
> +
> +	return sst25l_write_enable(flash, 0);
> +}

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
