Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYCANlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYCANlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 08:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbYCANlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 08:41:00 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:52476 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100AbYCANk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 08:40:59 -0500
Date: Sat, 1 Mar 2008 14:40:01 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>
Cc: linux-pm@lists.linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080301144001.771fa29c@mjolnir.drzeus.cx>
In-Reply-To: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 19:38:12 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> @@ -50,9 +58,16 @@ static int menu_select(struct cpuidle_device *dev)
>                         break;
>                 if (s->exit_latency > pm_qos_requirement(PM_QOS_CPU_DMA_LATENCY))
>                         break;
> +               if ((dev->states[i].flags & CPUIDLE_FLAG_DEEP) &&
> +                       time_before_eq(jiffies, data->last_deep_jif + MIN_DEEP_INTERVAL))
> +                       break;
>         }
>  

I guess another approach would be to refuse to enter deep sleep if the sleep time is less than 2 ms. That would mean we would not lose the long sleeps, but if it is just doing short sleeps then we would never enter C3...

Is there a decent way of testing which approach is actually doing the least damage?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
