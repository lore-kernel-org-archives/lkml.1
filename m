Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYBDXLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYBDXLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758310AbYBDXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:11:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2837 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbYBDXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:11:17 -0500
Date: Mon, 4 Feb 2008 23:11:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roel Kluin <12o3l@tiscali.nl>, Timur Tabi <timur@freescale.com>
Cc: liam.girdwood@wolfsonmicro.com, alsa-devel@alsa-project.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH][sound/soc/fsl/mpc8610_hpcd.c] duplicate strcasecmp test for "rj-master" in mpc8610_hpcd_probe()
Message-ID: <20080204231114.GA7842@sirena.org.uk>
Mail-Followup-To: Roel Kluin <12o3l@tiscali.nl>,
	Timur Tabi <timur@freescale.com>, liam.girdwood@wolfsonmicro.com,
	alsa-devel@alsa-project.org, lkml <linux-kernel@vger.kernel.org>
References: <47A77EB2.6070703@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A77EB2.6070703@tiscali.nl>
X-Cookie: Can you MAIL a BEAN CAKE?
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 10:08:02PM +0100, Roel Kluin wrote:
> In linus' git tree I found this problem. Is it also in the alsa tree?
> please confirm it's the right fix. The patch was not yet tested.

Timur, this looks like a good catch?

> --
> duplicate test for "rj-master"
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
> index f26c4b2..a00aac7 100644
> --- a/sound/soc/fsl/mpc8610_hpcd.c
> +++ b/sound/soc/fsl/mpc8610_hpcd.c
> @@ -314,9 +314,9 @@ static int mpc8610_hpcd_probe(struct of_device *ofdev,
>  	} else if (strcasecmp(sprop, "lj-master") == 0) {
>  		machine_data->dai_format = SND_SOC_DAIFMT_LEFT_J;
>  		machine_data->codec_clk_direction = SND_SOC_CLOCK_IN;
>  		machine_data->cpu_clk_direction = SND_SOC_CLOCK_OUT;
> -	} else if (strcasecmp(sprop, "rj-master") == 0) {
> +	} else if (strcasecmp(sprop, "rj-slave") == 0) {
>  		machine_data->dai_format = SND_SOC_DAIFMT_RIGHT_J;
>  		machine_data->codec_clk_direction = SND_SOC_CLOCK_OUT;
>  		machine_data->cpu_clk_direction = SND_SOC_CLOCK_IN;
>  	} else if (strcasecmp(sprop, "rj-master") == 0) {
