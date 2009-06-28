Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZF1ThA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZF1ThA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 15:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZF1Tgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 15:36:51 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:39263 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbZF1Tgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 15:36:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=WPOlMPOHIOgjhzVWhdluJLsEVQVbIYlHrohXvuQ2P5UI21zS2kfx0Z0caSq0IxUJvS
         OMbhpJYpkONc+ISbogww1J6sKTZYshtaXtotH3UPY1NCF0jHSWu5Sc/K7v2jVeKGVqZL
         A/KyRpEf5wvhdP5f2iSoYQp0mVvLzbrQ2xSmE=
Date: Sun, 28 Jun 2009 22:37:32 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       Tony Lindgren <tony@atomide.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] ASoC: OMAP: fix OMAP1510 broken PCM pointer
 callback
Message-Id: <20090628223732.53954402.jhnikula@gmail.com>
In-Reply-To: <200906280021.05931.jkrzyszt@tis.icnet.pl>
References: <200906280021.05931.jkrzyszt@tis.icnet.pl>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Jun 2009 00:21:05 +0200
Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> wrote:

> This patch tries to work around the problem of broken OMAP1510 PCM
> playback pointer calculation by replacing DMA function call that
> incorrectly tries to read the value form DMA hardware with a value
> computed locally from an already maintained variable
> omap_runtime_data.period_index.
> 
> Tested on OMAP5910 based Amstrad Delta (E3) using work in progress
> ASoC driver.
> 
> Based on linux-2.6-asoc.git v2.6.31-rc1.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> It seems that on OMAP1510, DMA Channel Progress Counter registers 
> (DMA_CPC_CH[0-8]) always contain values derived from DMA channels
> destination port address, even if constant, and there are no DMA
> registers available that would follow DMA channels source port
> address. Because of this limitation, current implementation of
> omap_get_dma_src_pos() for OMAP1510 is broken and doesn't seem to be
> easy correctable.
> 
Hi

Before going into workaround, did you try to change function
omap_get_dma_src_pos to read CSSA_L instead of CPC in
arch/arm/plat-omap/dma.c that I was speculating in mail below?

http://mailman.alsa-project.org/pipermail/alsa-devel/2009-June/018569.html

While CPC seems to be correct [1], you mentioned before that patch below
broke the older ALSA driver so it's worth to find out if the problem
can be corrected by simple one line fix (or two if omap_get_dma_dst_pos
need to be fixed as well).

http://marc.info/?l=linux-omap&m=121280267705523


-- 
Jarkko

1. http://www.google.com/search?q=spru674
