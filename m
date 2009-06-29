Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZF2GDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZF2GDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZF2GDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:03:22 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:38256 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbZF2GDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:03:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=gKBxb7ajtZWnLF29zNOTjbya7nvDlC3k0XoZxa6q93BDDvyqc3p4I4N9ykXb2hd2cH
         PFX/sKCGrL4W7BKYkvhZf3i3TdlXsmU6/7XqCQnGewmQvKHew35JdMmWHXzboQAcE3Fy
         vgkAW8K1lCoqSdOU9/5ZBkbRvpFxVootNLk00=
Date: Mon, 29 Jun 2009 09:04:03 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer
 callback
Message-Id: <20090629090403.5bfd35c8.jhnikula@gmail.com>
In-Reply-To: <200906290008.59640.jkrzyszt@tis.icnet.pl>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl>
	<20090628223732.53954402.jhnikula@gmail.com>
	<200906290008.59640.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 00:08:59 +0200
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> AFAIK, both CSSA_L and CDSA_L DMA registers are static. Loaded by CPU
> with 16 LSB of initial source and destination port addresses
> respectively, they are never updated by the DMA engine itself. That's
> why they can't be used for transfer progress indication unless
> updated by CPU.
> 
> The old omap-alsa driver was just updating them, intentionally or
> not, by reprogramming and restarting DMA every PCM period. That's why
> calculating PCM pointers from CSSA_L/CDSA_L worked.
> 
Thanks for finding out this. Good to know that OMAP low-level DMA code
now in this respect is as good as HW allows it.

> ASoC OMAP driver transfers whole PCM buffer with single DMA transfer,
> so it doesn't need to update DMA source/destination port address
> after initial playback/capture setup, even if restarting DMA, and
> actually never does this. Calculating PCM pointers from CSSA_L/CDSA_L
> registers without updating them every period would then be wrong.
> 
> For capture, reading CPC, that follows destination port address
> progress, just works fine (for both old and new driver). For
> playback, similar hardware functionality seems to be missing, so it
> has to be emulated in software if required.
> 
Kind an odd HW behaviour but that can happen. Probably it would be good
to explain this also in function omap_get_dma_src_pos.

Mark, I think this is fair to queue a fix for 2.6.31.

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
