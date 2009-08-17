Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZHQRrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZHQRrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbZHQRrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:47:49 -0400
Received: from www.tglx.de ([62.245.132.106]:44137 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbZHQRrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:47:48 -0400
Date: Mon, 17 Aug 2009 19:46:49 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
In-Reply-To: <20090817090319.20979986@nehalam>
Message-ID: <alpine.LFD.2.00.0908171943450.2782@localhost.localdomain>
References: <20090817090319.20979986@nehalam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009, Stephen Hemminger wrote:
> The following commit causes a change for kernels built with HRT but
> not actually using HRT.  I typically use the generic kernel we ship
> on test machines, and that kernel has NOHZ and HRT (for power savings/virt
> and HRT for QoS), but I want to be able to enable TSC as a clock source
> when doing performance tests with pktgen.
> 
> The machine in question is a several year old Opteron box, that
> normally reports clocksources: acpi_pm jiffies tsc
> but now with 2.6.31-rc6, it only has acpi_pm.
> 
> Since HRT/NOHZ is not really runtime configurable, I think the
> proper behavior is:

Isn't highres=off resp. nohz=off on the kernel command line not good
enough ?
 
>   * kernel reports all possible clocksources and chooses the best
>     by default
>   * if user demands a different clocksource, the kernel should use that
>     but degrade if necessary: ie. high-res timers have less (maybe even
>     only HZ accuracy), and nohz should be automatically disabled if
>     needed

We never implemented to back out from highres/nohz and I have no urge
to do so :)

Thanks,

	tglx
