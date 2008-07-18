Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbYGRHxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbYGRHxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYGRHxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:53:08 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50670 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751599AbYGRHxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:53:06 -0400
Date: Fri, 18 Jul 2008 08:53:02 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, gregkh@suse.de,
       lethal@linux-sh.org, i2c@lm-sensors.org, akpm@linux-foundation.org
Subject: Re: [i2c] [PATCH 03/05] resource: add new IORESOURCE_CLK type V2
Message-ID: <20080718075302.GP30539@fluff.org.uk>
References: <20080718074002.32713.73442.sendpatchset@rx1.opensource.se> <20080718074027.32713.15674.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718074027.32713.15674.sendpatchset@rx1.opensource.se>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 04:40:27PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> So far struct resource has been used with the types IORESOURCE_MEM,
> IORESOURCE_IO and IORESOUCE_IRQ to pass I/O and interrupt parameters
> to platform drivers. This patch extends this with IORESOURCE_CLK which
> should be used to pass a clock string to the platform driver. This
> string points out which specific clock that should be used with clk_get()
> for a certain driver instance.
> 
> Using a hard coded strings in the device driver won't do since we may
> have multiple instances of drivers that need to use different clocks.

It works already. The S3C24XX has n-number of H and P clocks fed to
each driver, differentiated by the device being supplied. This is
why clk_get() has two arguments, a device pointer and a name.

This might be useful to allow optional clocks to be passed, but I'm
not sure if it is necessary.
 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  Changes since V1:
>  - Use a new bit for IORESOURCE_CLK instead of switching to a counter
> 
>  include/linux/ioport.h |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> --- 0003/include/linux/ioport.h
> +++ work/include/linux/ioport.h	2008-07-18 14:29:48.000000000 +0900
> @@ -34,20 +34,21 @@ struct resource_list {
>   */
>  #define IORESOURCE_BITS		0x000000ff	/* Bus-specific bits */
>  
> -#define IORESOURCE_TYPE_BITS	0x00000f00	/* Resource type */
> +#define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
>  #define IORESOURCE_IO		0x00000100
>  #define IORESOURCE_MEM		0x00000200
>  #define IORESOURCE_IRQ		0x00000400
>  #define IORESOURCE_DMA		0x00000800
> +#define IORESOURCE_CLK		0x00001000
>  
> -#define IORESOURCE_PREFETCH	0x00001000	/* No side effects */
> -#define IORESOURCE_READONLY	0x00002000
> -#define IORESOURCE_CACHEABLE	0x00004000
> -#define IORESOURCE_RANGELENGTH	0x00008000
> -#define IORESOURCE_SHADOWABLE	0x00010000
> +#define IORESOURCE_PREFETCH	0x00002000	/* No side effects */
> +#define IORESOURCE_READONLY	0x00004000
> +#define IORESOURCE_CACHEABLE	0x00008000
> +#define IORESOURCE_RANGELENGTH	0x00010000
> +#define IORESOURCE_SHADOWABLE	0x00020000
>  
> -#define IORESOURCE_SIZEALIGN	0x00020000	/* size indicates alignment */
> -#define IORESOURCE_STARTALIGN	0x00040000	/* start field is alignment */
> +#define IORESOURCE_SIZEALIGN	0x00040000	/* size indicates alignment */
> +#define IORESOURCE_STARTALIGN	0x00080000	/* start field is alignment */
>  
>  #define IORESOURCE_DISABLED	0x10000000
>  #define IORESOURCE_UNSET	0x20000000
> 
> _______________________________________________
> i2c mailing list
> i2c@lm-sensors.org
> http://lists.lm-sensors.org/mailman/listinfo/i2c

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
