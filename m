Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYAOMWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYAOMWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYAOMWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:22:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35634 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbYAOMWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:22:18 -0500
Date: Tue, 15 Jan 2008 13:22:08 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: hrtimer.c devinit vs. cpuinit
Message-ID: <20080115122208.GA17122@uranus.ravnborg.org>
References: <1200357010.5887.72.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200357010.5887.72.camel@johannes.berg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 01:30:10AM +0100, Johannes Berg wrote:
> Hi,
> 
> Looking through hrtimer.c I noticed
> 
> static void __devinit init_hrtimers_cpu(int cpu)
> 
> static int __cpuinit hrtimer_cpu_notify(struct notifier_block *self,
>                                         unsigned long action, void *hcpu)
> 
> 
> Couldn't the first be __cpuinit as well?

As the only user of init_hrtimers_cpu is __cpuinit then it is a bug
that init_hrtimers_cpu is __devinit today.

So you are correct and it must be fixed.

	Sam
