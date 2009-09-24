Return-Path: <linux-kernel-owner+w=401wt.eu-S1752537AbZIXNux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbZIXNux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZIXNuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:50:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:32933 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbZIXNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:50:51 -0400
Date: Thu, 24 Sep 2009 15:51:08 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org
Subject: Re: [patch] perf timechart: Add a power-only mode
Message-ID: <20090924155108.38777ef5@infradead.org>
In-Reply-To: <4ABB7855.4080409@gmail.com>
References: <20090924154013.0675ab71@infradead.org>
	<4ABB7855.4080409@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 15:47:01 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> > -	for (cpu = 0; cpu < numcpus; cpu++) {
> > +	for (cpu = 0; cpu <= numcpus; cpu++) {
> 
> hmm, why test is now "cpu <= numcpus" ?

at this point numcpus is the highest number cpu...
and the graph would miss the "closing" frequency.


> > fopen("/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies",
> > "r");
> 
> if this cpu is offline

1) taking cpu 0 offline is stupid ;-)
(really, don't do that, there's only bad things to come from it)
2) if that file does not exist the fallback is graceful, we just use
the highest frequency we saw in the trace instead.

> 
>  /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:
> No such file or directory

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
