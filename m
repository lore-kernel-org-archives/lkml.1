Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbXCAJQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbXCAJQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 04:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933184AbXCAJQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 04:16:40 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:55586 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181AbXCAJQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 04:16:39 -0500
Date: Thu, 1 Mar 2007 18:14:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, a.zummo@towertech.it,
       vapier@gentoo.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 5/5] Blackfin: on-chip RTC controller driver
Message-ID: <20070301091408.GA4324@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>, a.zummo@towertech.it,
	vapier@gentoo.org, linux-kernel@vger.kernel.org
References: <1172722546.5264.79.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172722546.5264.79.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:15:46PM +0800, Wu, Bryan wrote:
> +#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __FUNCTION__, __LINE__, ## args)
> +#define stampit() stamp("here i am")
> +

Are these really necessary for the final driver? It's littered all over
the place, and presumably the driver should be functional enough to not
need this sort of debugging instrumentation.

[snip]

> +static void rtc_bfin_sync_pending(void)
> +{
> +	stampit();
> +	while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_COMPLETE)) {
> +		if (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING))
> +			break;
> +	}
> +	bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
> +}
> +
No timeout? (and superfluous braces)

> +	case RTC_PIE_ON:
> +		stampit();
> +		spin_lock_irq(&rtc->lock);
> +		rtc_bfin_sync_pending();

And it's also called under a spinlock each time.. this is a disaster
waiting to happen.
