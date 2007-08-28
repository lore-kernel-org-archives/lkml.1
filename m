Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbXH1WX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbXH1WX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 18:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXH1WXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 18:23:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbXH1WXr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 18:23:47 -0400
Date: Tue, 28 Aug 2007 15:23:09 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: DervishD <lkml@dervishd.net>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq affects traffic control rates
Message-ID: <20070828152309.7fe1ce91@freepuppy.rosehill.hemminger.net>
In-Reply-To: <20070828075155.GG17475@DervishD>
References: <20070828075155.GG17475@DervishD>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 09:51:55 +0200
DervishD <lkml@dervishd.net> wrote:

>     Hi all :)
> 
>     I noticed lately that my traffic control rates were being very slow,
> about 40% less than expected, and finally spotted the problem: cpufreq.
> 
>     Looks like HTB puts buckets according to the requested rate but
> assuming that the CPU is running at its default clock or something like
> that.
> 
>     Any way of fixing this without disabling cpufreq?
> 
>     I'm using kernel 2.6.20.14, Athlon64 1000/1800MHz, HZ=1000 and a
> combination of HTB/SFQ in my traffic control.
> 
>     Thanks a lot in advance :)
> 
>     Raúl Núñez de Arenas Coronado
> 

Is the problem configuration of network scheduler clock? In 2.6.20 and earlier, you
could use CPU cycle counter (later kernels only use time of day).  So try
switching to jiffies or gettimeofday.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
