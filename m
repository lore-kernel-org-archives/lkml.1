Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbZHGIyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbZHGIyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 04:54:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbZHGIyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 04:54:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:58866 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272AbZHGIyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 04:54:05 -0400
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH][2.6.31-rc5] ARM: OMAP: McBSP: Fix ASoC on OMAP1510 by fixing API of omap_mcbsp_start/stop
Date: Fri, 7 Aug 2009 11:52:47 +0300
User-Agent: KMail/1.11.4 (Linux/2.6.30-gentoo-r4; KDE/4.2.4; i686; ; )
Cc: ext Jarkko Nikula <jhnikula@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Tony Lindgren <tony@atomide.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
In-Reply-To: <1249628387-7372-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071152.47243.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 07 Aug 2009 08:52:51.0814 (UTC) FILETIME=[72646860:01CA173C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 09:59:47 ext Jarkko Nikula wrote:
> Simultaneous audio playback and capture on OMAP1510 can cause that second
> stream is stalled if there is enough delay between startup of the audio
> streams.
>
> Current implementation of the omap_mcbsp_start is starting both transmitter
> and receiver at the same time and it is called only for firstly started
> audio stream from the OMAP McBSP based ASoC DAI driver.
>
> Since DMA request lines on OMAP1510 are edge sensitive, the DMA request is
> missed if there is no DMA transfer set up at that time when the first word
> after McBSP startup is transmitted. The problem hasn't noted before since
> later OMAPs are using level sensitive DMA request lines.
>
> Fix the problem by changing API of omap_mcbsp_start and omap_mcbsp_stop by
> allowing to start and stop individually McBSP transmitter and receiver
> logics. Then call those functions individually for both audio playback
> and capture streams. This ensures that DMA transfer is setup before
> transmitter or receiver is started.
>
> Thanks to Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> for detailed problem
> analysis and Peter Ujfalusi <peter.ujfalusi@nokia.com> for info about DMA
> request line behavior differences between the OMAP generations.
>
> Reported-and-tested-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/plat-omap/include/mach/mcbsp.h |    4 +-
>  arch/arm/plat-omap/mcbsp.c              |   50
> +++++++++++++++++++----------- sound/soc/omap/omap-mcbsp.c             |  
> 10 +++---
>  3 files changed, 39 insertions(+), 25 deletions(-)

Acked-by: Peter Ujfalusi <peter.ujfalusi@nokia.com>

