Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZGFMq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZGFMq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZGFMqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:46:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZGFMqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:46:20 -0400
Subject: Re: CFS Scheduler : Period : for NCPUs : Code Suggestion Change
From: Peter Zijlstra <peterz@infradead.org>
To: Mitchell Erblich <erblichs@earthlink.net>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <B99DC9EB-9502-4E31-B829-6EB7EFC6212C@earthlink.net>
References: <B99DC9EB-9502-4E31-B829-6EB7EFC6212C@earthlink.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 06 Jul 2009 14:46:20 +0200
Message-Id: <1246884380.8143.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-30 at 18:36 -0700, Mitchell Erblich wrote:
> This is NOT A PATCH.
> 
> 	PLEASE include my email in the reply as I am not currently on
> 	the linux kernel mail alias.
> 
> 	This code snap is grabbed from what is believed to be a semi-current
> 	OS source (fxr.watson.org) comparison webpage.
> 
> 	Upon a quick CFS scheduler code walk, increasing the period
> 	should ALSO be dependent on the number of online/active CPUs.
> 
> 	The period should be adjusted based on the number of
> 	online CPUs. This change allows NCPUs * tasks without
> 	changing/increasing the period.
> 
> 	On first thought NR_CPUS should give the number of cpu on
> 	the system, however, this may be different from the number of
> 	CPUs online, thus..
> 
> 	Change #1: place after line 425
> 	int cpu, ncpu;
> 
> 
> 	Change #2: place before line 427
> 	for_each_online_cpu(cpu) {
> 		ncpu++;
>          }
> 	nr_running /=  ncpu;
> 	

Ah, but the nr_running number used is _per_ cpu already, so would that
address your concern?

