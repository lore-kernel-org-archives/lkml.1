Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZEMMZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZEMMZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 08:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbZEMMZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 08:25:35 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:41636 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbZEMMZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 08:25:34 -0400
X-Auth-Info: 5HBWc7JMY2YYeJKcS4e4IbXYiIHQfnNYd1s6/3m4Gn4=
Message-ID: <4A0ABC37.70104@denx.de>
Date: Wed, 13 May 2009 14:25:27 +0200
From: Anatolij Gustschin <agust@denx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] mb862xxfb: use CONFIG_OF instead of CONFIG_PPC_OF
References: <20090511222702.352192505@arndb.de>> <200905112237.12648.arnd@arndb.de>
In-Reply-To: <200905112237.12648.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

> With this change, the driver builds fine on Microblaze, which
> helps allyesconfig compile tests.

This patch is okay, just tested it. So
Acked-by: Anatolij Gustschin <agust@denx.de>

> I did not test sparc, but the change should have the same effect there.

unfortunately, OF platform part of this driver doesn't build on sparc
as there is no of_address_to_resource() and no NO_IRQ in sparc code.
There was an attempt to fix it by restricting the build of this part
to PPC, see http://lkml.org/lkml/2009/1/11/376

I will rebase the above mentioned patch by Julian Calaby and resubmit
soon. Thanks.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/video/mb862xx/mb862xxfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/mb862xx/mb862xxfb.c 
> b/drivers/video/mb862xx/mb862xxfb.c
> index fb64234..a28e3cf 100644
> --- a/drivers/video/mb862xx/mb862xxfb.c
> +++ b/drivers/video/mb862xx/mb862xxfb.c
> @@ -19,7 +19,7 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/pci.h>
> -#if defined(CONFIG_PPC_OF)
> +#if defined(CONFIG_OF)
>  #include <linux/of_platform.h>
>  #endif
>  #include "mb862xxfb.h"
