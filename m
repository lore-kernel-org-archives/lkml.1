Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbZGOEoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbZGOEoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZGOEob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:44:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42258 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbZGOEoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:44:30 -0400
Subject: Re: [PATCH 01/06] Fix compilation warning for
 sound/soc/codecs/wm8400.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Jaroslav Kysela <erex@perex.cz>, alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Takashi Iwai <iwai@suse.de>, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090715021826.4032.63752.sendpatchset@subratamodak.linux.ibm.com>
References: <20090715021826.4032.63752.sendpatchset@subratamodak.linux.ibm.com>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 10:13:38 +0530
Message-Id: <1247633018.2437.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Subrata,

On Wed, 2009-07-15 at 07:48 +0530, Subrata Modak wrote:
> Following fix is inspired by David Howells fix few days back:
> http://lkml.org/lkml/2009/7/9/109,
> 

Please check further of this thread :

http://marc.info/?l=linux-kernel&m=124756210124518&w=2


> Signed-off-by: Subrata Modak<subrata@linux.vnet.ibm.com>,
> ---
> 
> --- a/sound/soc/codecs/wm8400.c	2009-06-15 07:52:31.000000000 +0530
> +++ b/sound/soc/codecs/wm8400.c	2009-07-15 05:35:00.000000000 +0530
> @@ -1015,7 +1015,7 @@ static int wm8400_set_dai_pll(struct snd
>  {
>  	struct snd_soc_codec *codec = codec_dai->codec;
>  	struct wm8400_priv *wm8400 = codec->private_data;
> -	struct fll_factors factors;
> +	struct fll_factors uninitialized_var(factors);
>  	int ret;
>  	u16 reg;
>  
> 

This kind of warnings born due to not handling the variables properly.
Please try to understand the root cause of this warning, just shutting
this warning is of no use.

Please revise your patches, If you face any problems let me know.

Thanks,
--
JSR

