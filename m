Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbXKPNPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbXKPNPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 08:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757218AbXKPNPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 08:15:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbXKPNO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 08:14:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] snd hda suspend latency: shorten codec read
Date: Fri, 16 Nov 2007 14:31:39 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Mark Lord <lkml@rtr.ca>, perex@perex.cz, Takashi Iwai <tiwai@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Mark Lord <liml@rtr.ca>,
       Thomas Gleixner <tglx@linutronix.de>, len.brown@intel.com,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Len Brown <lenb@kernel.org>
References: <20071115181418.GA6603@ucw.cz> <20071116124319.GA21978@elte.hu> <20071116125824.GA28082@elte.hu>
In-Reply-To: <20071116125824.GA28082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161431.40784.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 16 of November 2007, Ingo Molnar wrote:
> 
> snd hda suspend latency goes down a second via the patch below.
> 
> 	Ingo
> 
> ------------->
> Subject: snd hda suspend latency: shorten codec read
> From: Ingo Molnar <mingo@elte.hu>
> 
> not sleeping for every codec read/write but doing a short udelay and
> a conditional reschedule has cut suspend+resume latency by about 1
> second on my T60.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  sound/pci/hda/hda_intel.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux/sound/pci/hda/hda_intel.c
> ===================================================================
> --- linux.orig/sound/pci/hda/hda_intel.c
> +++ linux/sound/pci/hda/hda_intel.c
> @@ -555,7 +555,8 @@ static unsigned int azx_rirb_get_respons
>  		}
>  		if (!chip->rirb.cmds)
>  			return chip->rirb.res; /* the last value */
> -		schedule_timeout_uninterruptible(1);
> +		udelay(10);
> +		cond_resched();
>  	} while (time_after_eq(timeout, jiffies));
>  
>  	if (chip->msi) {
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
