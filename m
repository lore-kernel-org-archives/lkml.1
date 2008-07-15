Return-Path: <linux-kernel-owner+w=401wt.eu-S1760732AbYGONEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760732AbYGONEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 09:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbYGONEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 09:04:32 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:54541 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbYGONEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 09:04:31 -0400
Date: Tue, 15 Jul 2008 15:04:29 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  ALSA Au1xpsc: psc not disabled when TX is idle
Message-ID: <20080715130429.GC27297@roarinelk.homelinux.net>
References: <487C9BA8.5010709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487C9BA8.5010709@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 02:44:24PM +0200, Roel Kluin wrote:
> Untested patch
> ---
> TX idleness isn't tested, but RX twice. PSC is not disabled when TX is idle
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/sound/soc/au1x/psc-i2s.c b/sound/soc/au1x/psc-i2s.c
> index ba4b5c1..9384702 100644
> --- a/sound/soc/au1x/psc-i2s.c
> +++ b/sound/soc/au1x/psc-i2s.c
> @@ -231,7 +231,7 @@ static int au1xpsc_i2s_stop(struct au1xpsc_audio_data *pscdata, int stype)
> 
>         /* if both TX and RX are idle, disable PSC */
>         stat = au_readl(I2S_STAT(pscdata));
> -       if (!(stat & (PSC_I2SSTAT_RB | PSC_I2SSTAT_RB))) {
> +       if (!(stat & (PSC_I2SSTAT_TB | PSC_I2SSTAT_RB))) {
>                 au_writel(0, I2S_CFG(pscdata));
>                 au_sync();
>                 au_writel(PSC_CTRL_SUSPEND, PSC_CTRL(pscdata));

Ah, stupid copy-paste error. Thanks!

Acked-by: Manuel Lauss <mano@roarinelk.homelinux.net>

-- 
 Manuel Lauss
