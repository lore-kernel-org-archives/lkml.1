Return-Path: <linux-kernel-owner+w=401wt.eu-S1761149AbXH3OoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761149AbXH3OoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXH3Onv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:43:51 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:39888 "EHLO
	outbound6-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756770AbXH3Onu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:43:50 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Thu, 30 Aug 2007 08:44:37 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Andres Salomon" <dilinger@queued.net>
cc: jayakumar.alsa@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
Subject: Re: ALSA: cs5535audio: correctly set dma->substream
Message-ID: <20070830144436.GH5851@cosmic.amd.com>
References: <20070829232812.80e4c71c.dilinger@queued.net>
MIME-Version: 1.0
In-Reply-To: <20070829232812.80e4c71c.dilinger@queued.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 30 Aug 2007 14:43:30.0202 (UTC)
 FILETIME=[21C8A7A0:01C7EB14]
X-WSS-ID: 6AC8081E0X86133977-02-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/07 23:28 -0400, Andres Salomon wrote:
> 
> We're never actually setting dma->substream to the current substream; that
> means the dma->substream checks that we do in the suspend/resume path
> are never satisfied, and the PRD registers are never correctly managed.  This
> changes it so that we set the substream when constructing the specific
> bus master DMA, and unsetting it when we tear down the BM's DMA.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>

> ---
> 
>  sound/pci/cs5535audio/cs5535audio_pcm.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/pci/cs5535audio/cs5535audio_pcm.c b/sound/pci/cs5535audio/cs5535audio_pcm.c
> index 5450a9e..e61f972 100644
> --- a/sound/pci/cs5535audio/cs5535audio_pcm.c
> +++ b/sound/pci/cs5535audio/cs5535audio_pcm.c
> @@ -164,6 +164,7 @@ static int cs5535audio_build_dma_packets(struct cs5535audio *cs5535au,
>  	jmpprd_addr = cpu_to_le32(lastdesc->addr +
>  				  (sizeof(struct cs5535audio_dma_desc)*periods));
>  
> +	dma->substream = substream;
>  	dma->period_bytes = period_bytes;
>  	dma->periods = periods;
>  	spin_lock_irq(&cs5535au->reg_lock);
> @@ -241,6 +242,7 @@ static void cs5535audio_clear_dma_packets(struct cs5535audio *cs5535au,
>  {
>  	snd_dma_free_pages(&dma->desc_buf);
>  	dma->desc_buf.area = NULL;
> +	dma->substream = NULL;
>  }
>  
>  static int snd_cs5535audio_hw_params(struct snd_pcm_substream *substream,
> 
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


