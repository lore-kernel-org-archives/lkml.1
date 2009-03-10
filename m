Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbZCJJA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbZCJJA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 05:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbZCJJAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 05:00:20 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56522 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753358AbZCJJAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 05:00:19 -0400
X-Sasl-enc: DnsEPtwGyKRD0zCrJC8s7YykZEjhq7Co0js8G+7nXocE 1236675615
Message-ID: <49B62C1D.4080509@ladisch.de>
Date: Tue, 10 Mar 2009 10:00:13 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Viral Mehta <viral.mehta@einfochips.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH] [SOUND] recording gain control
References: <49B5F8F5.8040100@einfochips.com>
In-Reply-To: <49B5F8F5.8040100@einfochips.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC alsa-devel)

Viral Mehta wrote:
> Hi,
> 
> I am trying to do gain control while RECORDING for my Audio Mic device.
> 
> My application opens /dev/mixer device and calls ioctl(fdmixer, 
> MIXER_WRITE(SOUND_MIXER_MIC), ...)
> 
> But, the call fails. It traces to sound/core/oss/mixer_oss.c file and 
> snd_mixer_oss_put_volume1() function.
> It never falls in "if (slot->present & SNDRV_MIXER_OSS_PRESENT_CVOLUME)" 
> as condition "if (slot->present & SNDRV_MIXER_OSS_PRESENT_PVOLUME) " 
> comes as false.
> 
> I think there is a bug in kernel and I think it should be like as below,
> 
> --- sound/core/oss/mixer_oss.c  2008-12-03 13:24:02.000000000 +0530
> +++ sound/core/oss/mixer_oss.c   2009-03-09 16:22:06.548766896 +0530
> @@ -688,7 +688,7 @@ static int snd_mixer_oss_put_volume1(str
> 
>      if (slot->present & SNDRV_MIXER_OSS_PRESENT_PVOLUME) {
>              snd_mixer_oss_put_volume1_vol(fmixer, pslot, 
> slot->numid[SNDRV_MIXER_OSS_ITEM_PVOLUME], left, right);
> -               if (slot->present & SNDRV_MIXER_OSS_PRESENT_CVOLUME)
> +       } else if (slot->present & SNDRV_MIXER_OSS_PRESENT_CVOLUME) {
>                      snd_mixer_oss_put_volume1_vol(fmixer, pslot, 
> slot->numid[SNDRV_MIXER_OSS_ITEM_CVOLUME], left, right);
>      } else if (slot->present & SNDRV_MIXER_OSS_PRESENT_GVOLUME) {
>              snd_mixer_oss_put_volume1_vol(fmixer, pslot, 
> slot->numid[SNDRV_MIXER_OSS_ITEM_GVOLUME], left, right);

Your mailer mangled the patch; see linux/Documentation/email-clients.txt.


Best regards,
Clemens
