Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYKHA3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYKHA3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 19:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbYKHA3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 19:29:32 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54352 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbYKHA3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 19:29:31 -0500
Date: Sat, 8 Nov 2008 01:32:10 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [patch 2.6.28-rc3-git] twl4030-core: allow reading entire
	register banks
Message-ID: <20081108003209.GB5993@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <200811071400.04181.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811071400.04181.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 02:00:03PM -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Minor change to the TWL4030 utility interface:  support reads
> of all 256 bytes in each register bank (vs just 255).  This
> can help when debugging, but is otherwise a NOP.
Applied to my for-next branch.
Thanks David.

Cheers,
Samuel.

 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/mfd/twl4030-core.c  |    4 ++--
>  include/linux/i2c/twl4030.h |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/drivers/mfd/twl4030-core.c
> +++ b/drivers/mfd/twl4030-core.c
> @@ -233,7 +233,7 @@ extern void twl4030_power_init(struct tw
>   *
>   * Returns the result of operation - 0 is success
>   */
> -int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, u8 num_bytes)
> +int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  {
>  	int ret;
>  	int sid;
> @@ -282,7 +282,7 @@ EXPORT_SYMBOL(twl4030_i2c_write);
>   *
>   * Returns result of operation - num_bytes is success else failure.
>   */
> -int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, u8 num_bytes)
> +int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes)
>  {
>  	int ret;
>  	u8 val;
> --- a/include/linux/i2c/twl4030.h
> +++ b/include/linux/i2c/twl4030.h
> @@ -78,8 +78,8 @@ int twl4030_i2c_read_u8(u8 mod_no, u8 *v
>   * IMPORTANT:  For twl4030_i2c_write(), allocate num_bytes + 1
>   * for the value, and populate your data starting at offset 1.
>   */
> -int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, u8 num_bytes);
> -int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, u8 num_bytes);
> +int twl4030_i2c_write(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
> +int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
>  
>  /*----------------------------------------------------------------------*/
>  

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
