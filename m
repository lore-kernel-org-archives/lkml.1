Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0BPLDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:03:00 -0500
Received: from mail1.perex.cz ([212.20.107.53]:59772 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab0BPLC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:02:59 -0500
Date: Tue, 16 Feb 2010 12:02:56 +0100 (CET)
From: Jaroslav Kysela <perex@perex.cz>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: bug list: range checking issues
In-Reply-To: <4B7A6CD9.10903@ladisch.de>
Message-ID: <alpine.LNX.2.00.1002161201140.28127@eeebox2.perex-int.cz>
References: <20100215124046.GB18821@bicker> <4B7A6CD9.10903@ladisch.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Clemens Ladisch wrote:

> This looks correct; the channels parameter is an interval, not a mask.
>
> 	if (!params->fifo_size) {
> 		if (snd_mask_min(&params->masks[SNDRV_PCM_HW_PARAM_FORMAT]) ==
> 		    snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_FORMAT]) &&
> 		    snd_mask_min(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS]) ==
> 		    snd_mask_max(&params->masks[SNDRV_PCM_HW_PARAM_CHANNELS])) {
>
> Jaroslav, I guess this should have been snd_interval_min/max?
> And shouldn't the parameters be accessed with hw_param_mask/interval?

Yes, the checks are not valid. Thanks for this notice. I fixed this issue 
in this commit:

http://git.alsa-project.org/?p=alsa-kernel.git;a=commitdiff;h=3be522a9514f58e0596db34898a514df206cadc5

 					Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project, Red Hat, Inc.

