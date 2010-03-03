Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0CCPvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:51:49 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48696 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab0CCPvs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:51:48 -0500
MIME-Version: 1.0
In-Reply-To: <20100303.025026.243831910.davem@davemloft.net>
References: <20100303.025026.243831910.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Mar 2010 08:51:27 -0700
X-Google-Sender-Auth: 06327d54fc9cc3d8
Message-ID: <fa686aa41003030751x6fbf4cc2t119f225e31bd45c8@mail.gmail.com>
Subject: Re: [PATCH] uartlite: Fix build on sparc.
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 3:50 AM, David Miller <davem@davemloft.net> wrote:
>
> We can get this driver enabled via MFD_TIMBERDALE which only
> requires GPIO to be on.
>
> But the of_address_to_resource() function is only present on
> powerpc and microblaze, so we have to conditionalize the
> CONFIG_OF probing bits on that.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>
>
> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
> index ab2ab3c..f0a6c61 100644
> --- a/drivers/serial/uartlite.c
> +++ b/drivers/serial/uartlite.c
> @@ -19,7 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <asm/io.h>
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))

ARM will probably end up using this driver.  How about simply
defined(CONFIG_OF) && !defined(CONFIG_SPARC)?

Or if you prefer, I could expedite my patch that moves
of_address_to_resource() into common code (it's currently in my test
branch).  I wasn't planning to merge it until 2.6.35, but it is pretty
low risk so I'd be comfortable merging it now.

g.
