Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZINO7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZINO7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZINO7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:59:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:59759 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZINO7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:59:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,383,1249282800"; 
   d="scan'208";a="726735916"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Mon, 14 Sep 2009 15:59:38 +0100
Subject: RE: [PATCH 20/29] ioat: switch watchdog and reset handler from
 workqueue	to timer
Thread-Topic: [PATCH 20/29] ioat: switch watchdog and reset handler from
 workqueue	to timer
Thread-Index: AcotB+poJD/Wv9uzQ5GD9hdXeTJtfgIQ4+Jg
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554818E@irsmsx504.ger.corp.intel.com>
References: <20090904022733.32667.77626.stgit@dwillia2-linux.ch.intel.com>
 <20090904023211.32667.37259.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904023211.32667.37259.stgit@dwillia2-linux.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Dan J wrote:
> In order to support dynamic resizing of the descriptor ring or polling
> for a descriptor in the presence of a hung channel the reset handler
> needs to make progress while in a non-preemptible context.  The current
> workqueue implementation precludes polling channel reset completion
> under spin_lock().
> 
> This conversion also allows us to return to opportunistic cleanup in the
> ioat2 case as the timer implementation guarantees at least one cleanup
> after every descriptor is submitted.  This means the worst case
> completion latency becomes the timer frequency (for exceptional
> circumstances), but with the benefit of avoiding busy waiting when the
> lock is contended.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

[...]
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -49,7 +49,7 @@ static void __ioat2_issue_pending(struct ioat2_dma_chan *ioat)
>  	void * __iomem reg_base = ioat->base.reg_base;
> 
>  	ioat->pending = 0;
> -	ioat->dmacount += ioat2_ring_pending(ioat);
> +	ioat->dmacount += ioat2_ring_pending(ioat);;
double semicolon

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>