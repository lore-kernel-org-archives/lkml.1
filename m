Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbYBGQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbYBGQnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 11:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYBGQnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 11:43:01 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:4589 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932271AbYBGQm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 11:42:58 -0500
Date: Thu, 7 Feb 2008 17:42:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, shemminger@linux-foundation.org,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] apanel: fix kconfig dependencies
Message-ID: <20080207174251.1b895234@hyperion.delvare>
In-Reply-To: <20080206162754.73114579.randy.dunlap@oracle.com>
References: <20080206162754.73114579.randy.dunlap@oracle.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, 6 Feb 2008 16:27:54 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Add I2C to config since the driver makes several i2c*() calls.

Correct.

> 
> Add PCI to config because the config selects I2C_I801, which depends
> on PCI, but currently config* does not follow dependency chains,
> so randconfig can enable INPUT_APANEL even when PCI is not enabled,
> which leads to these warnings:
> linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:641: error: implicit declaration of function 'pci_request_region'
> /linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:681: error: implicit declaration of function 'pci_release_region'

I'd rather drop the "select I2C_I801" if the config system can't handle
it properly. It's not strictly needed (not a build-time dependency), an
addition to the help text would work as well. Adding dependencies to
make our selections happy is a bit confusing and likely to cause
trouble in the future (as dependencies can change...)

> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/input/misc/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.24-mm1.orig/drivers/input/misc/Kconfig
> +++ linux-2.6.24-mm1/drivers/input/misc/Kconfig
> @@ -42,7 +42,7 @@ config INPUT_M68K_BEEP
>  
>  config INPUT_APANEL
>  	tristate "Fujitsu Lifebook Application Panel buttons"
> -	depends on X86
> +	depends on X86 && I2C && PCI
>  	select I2C_I801
>  	select INPUT_POLLDEV
>  	select CHECK_SIGNATURE


-- 
Jean Delvare
