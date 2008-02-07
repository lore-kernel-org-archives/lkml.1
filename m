Return-Path: <linux-kernel-owner+w=401wt.eu-S934408AbYBGVrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408AbYBGVrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762807AbYBGVrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:47:05 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1904 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762702AbYBGVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:47:03 -0500
Date: Thu, 7 Feb 2008 22:46:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, shemminger@linux-foundation.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] apanel: fix kconfig dependencies
Message-ID: <20080207224658.2b9091bf@hyperion.delvare>
In-Reply-To: <20080207110412.792db623.randy.dunlap@oracle.com>
References: <20080206162754.73114579.randy.dunlap@oracle.com>
	<20080207174251.1b895234@hyperion.delvare>
	<20080207110412.792db623.randy.dunlap@oracle.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Thu, 7 Feb 2008 11:04:12 -0800, Randy Dunlap wrote:
> OK.  What did you have in mind for the help text.  I changed it
> a small bit.
> 
> I also added "depends on LEDS_CLASS" since defconfig didn't have that
> set, but the build failed with wanting symbols that it provides.
> 
> Updated patch:
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add I2C to config since the driver makes several i2c*() calls.
> 
> Add to help text that the Intel I2C ICH (i801) driver is also needed
> for this kernel.
> 
> Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
> ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
> ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/input/misc/Kconfig |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-2.6.24-mm1.orig/drivers/input/misc/Kconfig
> +++ linux-2.6.24-mm1/drivers/input/misc/Kconfig
> @@ -42,14 +42,14 @@ config INPUT_M68K_BEEP
>  
>  config INPUT_APANEL
>  	tristate "Fujitsu Lifebook Application Panel buttons"
> -	depends on X86
> -	select I2C_I801
> +	depends on X86 && I2C && LEDS_CLASS
>  	select INPUT_POLLDEV
>  	select CHECK_SIGNATURE
>  	help
>  	 Say Y here for support of the Application Panel buttons, used on
>  	 Fujitsu Lifebook. These are attached to the mainboard through
> -	 an SMBus interface managed by the I2C Intel ICH (i801) driver.
> +	 an SMBus interface managed by the I2C Intel ICH (i801) driver,
> +	 which you should also build for this kernel.
>  
>  	 To compile this driver as a module, choose M here: the module will
>  	 be called apanel.

Yeah, looks OK to me.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
