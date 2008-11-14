Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYKNBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYKNBC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:02:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYKNBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:02:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbYKNBCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:02:48 -0500
Date: Thu, 13 Nov 2008 17:02:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarkko Nikula <jarkko.nikula@nokia.com>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net, jarkko.nikula@nokia.com,
       stable@kernel.org
Subject: Re: [patch 2.6.28-rc4] gpiolib: extend gpio label column width in
 debugfs file
Message-Id: <20081113170211.23bf0343.akpm@linux-foundation.org>
In-Reply-To: <1226472973-16271-1-git-send-email-jarkko.nikula@nokia.com>
References: <1226472973-16271-1-git-send-email-jarkko.nikula@nokia.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 08:56:13 +0200
Jarkko Nikula <jarkko.nikula@nokia.com> wrote:

> There are already various drivers having bigger label than 12 bytes. Most
> of them fit well under 20 bytes but make column width exact so that
> oversized labels don't mess up output alignment.

Please provide before-and-after example output for this sort of change
so that we can better understand its effect.

> Signed-off-by: Jarkko Nikula <jarkko.nikula@nokia.com>
> ---
>  drivers/gpio/gpiolib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index faa1cc6..82020ab 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1134,7 +1134,7 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  			continue;
>  
>  		is_out = test_bit(FLAG_IS_OUT, &gdesc->flags);
> -		seq_printf(s, " gpio-%-3d (%-12s) %s %s",
> +		seq_printf(s, " gpio-%-3d (%-20.20s) %s %s",
>  			gpio, gdesc->label,
>  			is_out ? "out" : "in ",
>  			chip->get

This is a non-backward-compatible change to a userspace interface.  It
looks like a pretty safe one, but this is always a fairly big deal.

If we're going to make this change then we should backport it to
2.6.27.x, 2.6.26.x and to 2.6.25.x to minimise the chance that someone
will write a parser which works on one kernel version and fails on
another.

David?  Thoughts?
