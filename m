Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbXJMPWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbXJMPWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 11:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXJMPWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 11:22:05 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40487
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbXJMPWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 11:22:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [patch 7/8] b43 wireless needs <linux/io.h>
Date: Sat, 13 Oct 2007 17:21:00 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefano Brivio <st3@riseup.net>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>,
       John Linville <linville@tuxdriver.com>
References: <20071013123123.085686856@mail.of.borg> <20071013123414.160200918@mail.of.borg>
In-Reply-To: <20071013123414.160200918@mail.of.borg>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710131721.00997.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 October 2007 14:31:30 Geert Uytterhoeven wrote:
> b43 wireless needs <linux/io.h>
> 
> linux/drivers/net/wireless/b43/pio.h: In function 'b43_pio_write':
> linux/drivers/net/wireless/b43/pio.h:89: error: implicit declaration of function 'mmiowb'
> 
> linux/drivers/net/wireless/b43/phy.c: In function 'b43_phy_write':
> linux/drivers/net/wireless/b43/phy.c:301: error: implicit declaration of function 'mmiowb'
> 
> linuxdrivers/net/wireless/b43/sysfs.c: In function 'b43_attr_interfmode_store':
> linuxdrivers/net/wireless/b43/sysfs.c:147: error: implicit declaration of function 'mmiowb'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <larry.finger@lwfinger.net>

> ---
>  drivers/net/wireless/b43/phy.c   |    1 +
>  drivers/net/wireless/b43/pio.h   |    1 +
>  drivers/net/wireless/b43/sysfs.c |    5 +++--
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/wireless/b43/phy.c
> +++ b/drivers/net/wireless/b43/phy.c
> @@ -26,6 +26,7 @@
>  */
>  
>  #include <linux/delay.h>
> +#include <linux/io.h>
>  #include <linux/types.h>
>  
>  #include "b43.h"
> --- a/drivers/net/wireless/b43/pio.h
> +++ b/drivers/net/wireless/b43/pio.h
> @@ -4,6 +4,7 @@
>  #include "b43.h"
>  
>  #include <linux/interrupt.h>
> +#include <linux/io.h>
>  #include <linux/list.h>
>  #include <linux/skbuff.h>
>  
> --- a/drivers/net/wireless/b43/sysfs.c
> +++ b/drivers/net/wireless/b43/sysfs.c
> @@ -23,13 +23,14 @@
>  
>  */
>  
> +#include <linux/capability.h>
> +#include <linux/io.h>
> +
>  #include "b43.h"
>  #include "sysfs.h"
>  #include "main.h"
>  #include "phy.h"
>  
> -#include <linux/capability.h>
> -
>  #define GENERIC_FILESIZE	64
>  
>  static int get_integer(const char *buf, size_t count)
> 



-- 
Greetings Michael.
