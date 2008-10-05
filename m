Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbYJETlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbYJETlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbYJETlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:41:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43498 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYJETlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:41:04 -0400
Date: Sun, 5 Oct 2008 20:40:35 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alex Raimondi <raimondi@miromico.ch>
Subject: Re: [PATCH] Change comment in include linux/clk.h
Message-ID: <20081005194035.GA23047@flint.arm.linux.org.uk>
References: <1223234438-28004-1-git-send-email-haavard.skinnemoen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223234438-28004-1-git-send-email-haavard.skinnemoen@atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 09:20:38PM +0200, Haavard Skinnemoen wrote:
> From: Alex Raimondi <raimondi@miromico.ch>
> 
> clk_get and clk_put may not be used from within interrupt
> context. Change comment to this function.
> 
> Signed-off-by: Alex Raimondi <raimondi@miromico.ch>
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---
> I see several ARM implementation using mutexes for locking in these
> functions. So I assume we never want to call them from interrupt
> context, right?

Correct.  I'm not sure why anyone would even consider doing so.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

> 
>  include/linux/clk.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 5ca8c6f..7787773 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -35,6 +35,8 @@ struct clk;
>   * clk_get may return different clock producers depending on @dev.)
>   *
>   * Drivers must assume that the clock source is not enabled.
> + *
> + * clk_get should not be called from within interrupt context.
>   */
>  struct clk *clk_get(struct device *dev, const char *id);
>  
> @@ -76,6 +78,8 @@ unsigned long clk_get_rate(struct clk *clk);
>   * Note: drivers must ensure that all clk_enable calls made on this
>   * clock source are balanced by clk_disable calls prior to calling
>   * this function.
> + *
> + * clk_put should not be called from within interrupt context.
>   */
>  void clk_put(struct clk *clk);
>  
> -- 
> 1.5.6.5
> 

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
