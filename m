Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYGBIvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYGBIvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYGBIvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:51:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbYGBIvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:51:42 -0400
Date: Wed, 2 Jul 2008 01:49:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: kay.sievers@vrfy.org, mreimer@vpop.net,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.26-rc8] drivers/power:  fix platform driver
 hotplug/coldplug
Message-Id: <20080702014906.6303fd97.akpm@linux-foundation.org>
In-Reply-To: <200807020013.14579.david-b@pacbell.net>
References: <200807020013.14579.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 00:13:14 -0700 David Brownell <david-b@pacbell.net> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Since 43cc71eed1250755986da4c0f9898f9a635cb3bf

Linus chucks a wobbly if we quote bare SHA hashes at him.  I updated
the changelog appropriately.

>, the platform
> modalias is prefixed with "platform:". Add MODULE_ALIAS() to the
> hotpluggable "power" drivers drivers, to re-enable auto loading.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> [ dbrownell@users.sourceforge.net: one was missing ]
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/power/ds2760_battery.c |    2 ++
>  drivers/power/pda_power.c      |    2 ++
>  2 files changed, 4 insertions(+)
> 
> --- a/drivers/power/ds2760_battery.c	2008-07-01 23:49:46.000000000 -0700
> +++ b/drivers/power/ds2760_battery.c	2008-07-01 23:51:48.000000000 -0700
> @@ -433,6 +433,8 @@ static int ds2760_battery_resume(struct 
>  
>  #endif /* CONFIG_PM */
>  
> +MODULE_ALIAS("platform:ds2760-battery");
> +
>  static struct platform_driver ds2760_battery_driver = {
>  	.driver = {
>  		.name = "ds2760-battery",
> --- a/drivers/power/pda_power.c	2008-07-02 00:10:18.000000000 -0700
> +++ b/drivers/power/pda_power.c	2008-07-02 00:10:36.000000000 -0700
> @@ -362,6 +362,8 @@ static int pda_power_resume(struct platf
>  #define pda_power_resume NULL
>  #endif /* CONFIG_PM */
>  
> +MODULE_ALIAS("platform:pda-power");
> +
>  static struct platform_driver pda_power_pdrv = {
>  	.driver = {
>  		.name = "pda-power",

Do we think this is needed in 2.6.26?

In 2.6.25.x?
