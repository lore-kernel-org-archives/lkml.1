Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZBIWh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZBIWh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:37:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbZBIWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:37:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbZBIWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:37:47 -0500
Date: Mon, 9 Feb 2009 14:37:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "hartleys" <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH] auxdisplay: remove PARPORT dependency
Message-Id: <20090209143716.57467016.akpm@linux-foundation.org>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090120BD69@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE19090120BD69@mi8nycmail19.Mi8.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(please cc the maintainers on patches)

On Fri, 6 Feb 2009 19:06:51 -0500
"hartleys" <hartleys@visionengravers.com> wrote:

> Remove PARPORT dependency for Auxiliary Display support.
> 
> This is not needed since the dependency for the KS0108 driver is
> PARPORT_PC.
> 

OK, but the patch also accidentally removes the parport dependency from
cfag12864b.c and cfag12864bfb.c.

A quick grep indicates that those drivers don't need parport, but I
didn't look very closely.

> 
> diff --git a/drivers/auxdisplay/Kconfig b/drivers/auxdisplay/Kconfig
> index 14b9d5f..c07e725 100644
> --- a/drivers/auxdisplay/Kconfig
> +++ b/drivers/auxdisplay/Kconfig
> @@ -6,7 +6,6 @@
>  #
>  
>  menuconfig AUXDISPLAY
> -	depends on PARPORT
>  	bool "Auxiliary Display support"
>  	---help---
>  	  Say Y here to get to see options for auxiliary display
> drivers.
> @@ -14,7 +13,7 @@ menuconfig AUXDISPLAY
>  
>  	  If you say N, all options in this submenu will be skipped and
> disabled.
>  
> -if AUXDISPLAY && PARPORT
> +if AUXDISPLAY
>  
>  config KS0108
>  	tristate "KS0108 LCD Controller" 

Your email client wordwraps patches.  Please fix that up for next time.

