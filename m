Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbXLCSx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbXLCSx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbXLCSxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:53:50 -0500
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:30488 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751595AbXLCSxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:53:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=erCG921/YyHTvu1EJIbS3hbrInA9XUG+BLyvBFTwj/ImY2yuCHlLUCOwVtcF2k1uHkCM88SRhfgFkIDBYhvr0IbTrXNPCE3qjXXl3amq7n+2bwUsVCMV66AS/A/m/x1JeK7DuQLyuBxe6KpSI/4qdN4Uxi1x+UnjuEPR1aSiLXs=  ;
X-YMail-OSG: uCp7Kn0VM1k84RkGWUc01vGRBssmTu11PHdPl4Zr8mkKQh_JdW2_MXSWVLYXIwl1QQMCX35kXg--
From: David Brownell <david-b@pacbell.net>
To: Jan Altenberg <jan.altenberg@linutronix.de>
Subject: Re: [PATCH][AT91] Fix compile error for at91rm9200 in latest git
Date: Mon, 3 Dec 2007 10:53:42 -0800
User-Agent: KMail/1.9.6
Cc: linux@maxim.org.za, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
References: <1196675122.3832.18.camel@bender.lan>
In-Reply-To: <1196675122.3832.18.camel@bender.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712031053.43316.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007, Jan Altenberg wrote:
> 
> at91rm9200ek doesn't compile in latest git:
> ...
> The offending commit is:
> 
> [jan@bender linux-2.6]$ git-bisect good
> f230d3f53d72d05bcb5666ab7e2eccd49c8b3a15 is first bad commit
> commit f230d3f53d72d05bcb5666ab7e2eccd49c8b3a15
> Author: Andrew Victor <andrew@sanpeople.com>
> Date:   Mon Nov 19 13:47:20 2007 +0100
> 
>     [ARM] 4650/1: AT91: New-style init of I2C, support for i2c-gpio
>     ...
>     
>     Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
>     Signed-off-by: Andrew Victor <andrew@sanpeople.com>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Which is a combination of two patches, which seems to have dropped the
chunk you show below.  The reason this seems to have my signoff is
that I originated one of those patches, and parts of the second, but
in fact I had never seen f230d3f53d72d05bcb5666ab7e2eccd49c8b3a15
until after this email ...

Your patch looks correct, and seems to be the only obvious chunk
that's missing.  So, I'll ack it FWIW ... usual policy for these
patches is to go through Russell.


I'll note that the whole "mark Atmel's TWI controller BROKEN" patchh
series, making everything use the i2c-gpio instead, has turned up
one more issue at the I2C level:  the i2c_adapter.class for i2c-gpio
needs to include at least the HWMON class bit.

- Dave


> This patch adds the missing i2c_board_info struct (grabbed from Andrew
> Victor's tree).
> 
> Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
> 
> ---
> diff --git a/arch/arm/mach-at91/board-ek.c b/arch/arm/mach-at91/board-ek.c
> index d05b1b2..53a5ef9 100644
> --- a/arch/arm/mach-at91/board-ek.c
> +++ b/arch/arm/mach-at91/board-ek.c
> @@ -109,6 +109,15 @@ static struct spi_board_info ek_spi_devices[] = {
>  #endif
>  };
>  
> +static struct i2c_board_info __initdata ek_i2c_devices[] = {
> +	{
> +		I2C_BOARD_INFO("ics1523", 0x26),
> +	},
> +	{
> +		I2C_BOARD_INFO("dac3550", 0x4d),
> +	}
> +};
> +
>  #define EK_FLASH_BASE	AT91_CHIPSELECT_0
>  #define EK_FLASH_SIZE	0x200000
> 
> 


