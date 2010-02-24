Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab0BXKUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:20:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43299 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756267Ab0BXKUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:20:46 -0500
Date: Wed, 24 Feb 2010 10:20:44 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] Regulators: wm8994 - clean up driver data after
 removal
Message-ID: <20100224102044.GF18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073844.15964.61692.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073844.15964.61692.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:38:44PM -0800, Dmitry Torokhov wrote:
> It is a good tone to reset driver data after unbinding the device.

You mean "good style" here.  Anyway,

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

BTW, this patch is an example of the sort of stuff I'm talking about
with adding additional changes that aren't documented in the
changelog.  As well as nulling out the driver data you're also...

>  struct wm8994_ldo {
>  	int enable;
> -	int is_enabled;
> +	bool is_enabled;

...doing a conversion to bool here and...

> @@ -276,6 +278,7 @@ static struct platform_driver wm8994_ldo_driver = {
>  	.remove = __devexit_p(wm8994_ldo_remove),
>  	.driver		= {
>  		.name	= "wm8994-ldo",
> +		.owner	= THIS_MODULE,
>  	},

...adding this.  The change you mention in the changelog is a single
line edit but with these extra changes the overall diffstat becomes:

>  drivers/regulator/wm8994-regulator.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
