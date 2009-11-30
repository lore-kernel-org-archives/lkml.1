Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZK3WXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZK3WXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZK3WXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:23:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbZK3WXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:23:53 -0500
Date: Mon, 30 Nov 2009 14:23:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       linux-rtc <rtc-linux@googlegroups.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4]ARM: NUC900: add RTC driver support for nuc910 and
 nuc920
Message-Id: <20091130142320.01f0c212.akpm@linux-foundation.org>
In-Reply-To: <4B126B03.1060901@gmail.com>
References: <4B126B03.1060901@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Nov 2009 20:37:23 +0800
Wan ZongShun <mcuos.com@gmail.com> wrote:

> Dear Alessandro,
> 
> I fixed this patch and submitted it again.
> 
> thanks!
> 
> signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

That's not a terribly useful changelog.

>
> ...
>
> +static void check_rtc_power(struct nuc900_rtc *nuc900_rtc)
> +{
> +	unsigned int i;
> +	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);
> +
> +	mdelay(10);
> +
> +	__raw_writel(AERPOWERON, nuc900_rtc->rtc_reg + REG_RTC_AER);
> +
> +	for (i = 0; i < 1000000; i++) {
> +		if (__raw_readl(nuc900_rtc->rtc_reg + REG_RTC_AER) & AERRWENB)
> +			break;
> +	}
> +}

I don't like that function much.

- It's not obvious what it actually does (I don't know), so it should
  have some comment explaining this.

- It's called "check_rtc_power", but it doesn't actually "check"
  anything.

- If that enormously expensive loop times out, the function will not
  inform the caller of this, so it will be called again and again and
  will continue to be enormously expensive.

>
> ...
>
