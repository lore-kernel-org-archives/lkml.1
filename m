Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbZAQQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbZAQQp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbZAQQpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:45:18 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47697 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbZAQQpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:45:16 -0500
Date: Sat, 17 Jan 2009 17:44:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] platform/x86: eeepc-laptop uses INPUT
Message-ID: <20090117164457.GJ10825@elte.hu>
References: <20090114162502.GA20451@elte.hu> <20090117024119.GB2291@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117024119.GB2291@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1408]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> eeepc-laptop uses the input layer, so needs to depend on it.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> Ugh. The drivers in here seem to use a mixture of select and depends - 
> I've just followed what was already being used, but have no idea what 
> the convention really is here.
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index e65448e..d4908e0 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -281,6 +281,7 @@ config EEEPC_LAPTOP
>  	select BACKLIGHT_CLASS_DEVICE
>  	select HWMON
>  	select RFKILL
> +	select INPUT

hm, that looks wrong - selecting an interactive option like CONFIG_INPUT 
is a bad idea and can lead to further dependency problems. depends-on 
might be better. (any distro kernel will have INPUT enabled anyway, so 
this is not a reduction in utility)

	Ingo
