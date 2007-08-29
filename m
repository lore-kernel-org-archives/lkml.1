Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbXH2RU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbXH2RU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXH2RUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:20:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751443AbXH2RUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:20:16 -0400
Date: Wed, 29 Aug 2007 10:20:05 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: DervishD <lkml@dervishd.net>, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq affects traffic control rates
Message-ID: <20070829102005.5450723e@freepuppy.rosehill.hemminger.net>
In-Reply-To: <Pine.LNX.4.64.0708291725000.24730@fbirervta.pbzchgretzou.qr>
References: <20070828075155.GG17475@DervishD>
	<20070828152309.7fe1ce91@freepuppy.rosehill.hemminger.net>
	<Pine.LNX.4.64.0708291725000.24730@fbirervta.pbzchgretzou.qr>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 17:26:24 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Aug 28 2007 15:23, Stephen Hemminger wrote:
> >>     I noticed lately that my traffic control rates were being very slow,
> >> about 40% less than expected, and finally spotted the problem: cpufreq.
> >> 
> >>     Looks like HTB puts buckets according to the requested rate but
> >> assuming that the CPU is running at its default clock or something like
> >> that.
> >> 
> >Is the problem configuration of network scheduler clock? In 2.6.20 and earlier, you
> >could use CPU cycle counter (later kernels only use time of day).  So try
> >switching to jiffies or gettimeofday.
> 
> This should not have been removed. CPUs with constant_tsc
> could still be used with "CPU cycle counter" method.
> 
> 
> 	Jan

It was removed because the core clock subsystem now manages the choice
of CPU clock correctly and should provide the highest resolution possible
on the hardware.

Plus a whole bunch of grotty macro code gets removed. And the math
handling was more standard/simpler.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
