Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbZHPN2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbZHPN2O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZHPN2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:28:13 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:58429 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbZHPN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:28:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAIulh0pR9cbZ/2dsb2JhbACbfbU+CYIqgWYFgik
Date: Sun, 16 Aug 2009 15:28:12 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] [WATCHDOG] Add support for WM831x watchdog
Message-ID: <20090816132812.GO4302@infomag.iguana.be>
References: <1249922635-31864-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1249922635-31864-5-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249922635-31864-5-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> The WM831x series of devices provide a watchdog with configurable
> behaviour on timer expiry.
> 
> Currently this driver support refreshes via a register or GPIO line and
> autonomous refreshes from a hardware source (eg, a clock).
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

the driver is OK. Just 2 small remarks:
> +static struct watchdog_info ident = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
> +	.identity = "WM831x Watchdog",
> +};

this can be static const struct in the future (need to do a clean-up on that).

> +#define WM831X_WDOG_SECACT_MASK                 0x0300  /* WDOG_SECACT - [9:8] */
> +#define WM831X_WDOG_SECACT_SHIFT                     8  /* WDOG_SECACT - [9:8] */
> +#define WM831X_WDOG_SECACT_WIDTH                     2  /* WDOG_SECACT - [9:8] */
> +#define WM831X_WDOG_PRIMACT_MASK                0x0030  /* WDOG_PRIMACT - [5:4] */
> +#define WM831X_WDOG_PRIMACT_SHIFT                    4  /* WDOG_PRIMACT - [5:4] */
> +#define WM831X_WDOG_PRIMACT_WIDTH                    2  /* WDOG_PRIMACT - [5:4] */

These lines exceed 80 characters. Is there any reason why we can't reduce the spacing between the name and the value?

Just let me know how we will proceed on my second question. I can then add this to the linux-2.6-watchdog-next tree.

Kind regards,
Wim.

