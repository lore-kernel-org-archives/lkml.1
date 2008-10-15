Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYJOLz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYJOLz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 07:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYJOLzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 07:55:21 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:38125 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbYJOLzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 07:55:20 -0400
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: Don't use =?UTF-8?Q?NO=5FIRQ=20in=20WM=38=33=35=30?=
MIME-Version: 1.0
Date: Wed, 15 Oct 2008 07:55:17 -0400
From: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@kernel.org>
Reply-To: sameo@openedhand.com
In-Reply-To: <1224066054-24401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1224066054-24401-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Message-ID: <9fb8beea82becda1567755f13aab4c11@localhost>
User-Agent: RoundCube Webmail/0.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 15 Oct 2008 11:20:54 +0100, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> NO_IRQ is only defined on some architectures - the general way to test
> for an invalid IRQ in the modern kernel is by comparing with zero.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Applied, thanks.
I'll send a pull request to Linus soon.

Cheers,
Samuel.


> ---
> 
> This is a build fix for platforms that don't define NO_IRQ (which is
> most of them).  Please merge as soon as possible.
> 
>  drivers/mfd/wm8350-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
> index 25a7a5d..bf87f67 100644
> --- a/drivers/mfd/wm8350-core.c
> +++ b/drivers/mfd/wm8350-core.c
> @@ -1217,7 +1217,7 @@ int wm8350_device_init(struct wm8350 *wm8350, int
> irq,
>  
>  	mutex_init(&wm8350->irq_mutex);
>  	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
> -	if (irq != NO_IRQ) {
> +	if (irq) {
>  		ret = request_irq(irq, wm8350_irq, 0,
>  				  "wm8350", wm8350);
>  		if (ret != 0) {
>
