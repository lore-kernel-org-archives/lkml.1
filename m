Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbYISLFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbYISLFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 07:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYISLFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 07:05:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46933 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754466AbYISLFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 07:05:09 -0400
Date: Fri, 19 Sep 2008 11:56:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 4/5] watchdog: move omap_wdt.h to include/linux/watchdog
Message-ID: <20080919115627.343a2847@lxorguk.ukuu.org.uk>
In-Reply-To: <1221820359-8943-5-git-send-email-felipe.balbi@nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
	<1221820359-8943-5-git-send-email-felipe.balbi@nokia.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 13:32:38 +0300
Felipe Balbi <felipe.balbi@nokia.com> wrote:

> Create a new include/linux/watchdog directory
> for holding watchdog chips headers, move omap_wdt.h
> to the new location and update the include path in
> the driver source.

Headers that are driver private belong with the driver. In fact in many
cases they belong *in* the driver C file but that depends how much is
there.



> +#define OMAP_WATCHDOG_REV		(0x00)
> +#define OMAP_WATCHDOG_SYS_CONFIG	(0x10)
> +#define OMAP_WATCHDOG_STATUS		(0x14)
> +#define OMAP_WATCHDOG_CNTRL		(0x24)
> +#define OMAP_WATCHDOG_CRR		(0x28)
> +#define OMAP_WATCHDOG_LDR		(0x2c)
> +#define OMAP_WATCHDOG_TGR		(0x30)
> +#define OMAP_WATCHDOG_WPS		(0x34)
> +#define OMAP_WATCHDOG_SPR		(0x48)
> +
> +/* Using the prescaler, the OMAP watchdog could go for many
> + * months before firing.  These limits work without scaling,
> + * with the 60 second default assumed by most tools and docs.
> + */
> +#define TIMER_MARGIN_MAX	(24 * 60 * 60)	/* 1 day */
> +#define TIMER_MARGIN_DEFAULT	60	/* 60 secs */
> +#define TIMER_MARGIN_MIN	1
> +
> +#define PTV			0	/* prescale */
> +#define GET_WLDR_VAL(secs)	(0xffffffff - ((secs) * (32768/(1<<PTV))) + 1)
> +
> +#endif				/* _OMAP_WATCHDOG_H */

You could just drop these into the C file given how small they are.

Alan
