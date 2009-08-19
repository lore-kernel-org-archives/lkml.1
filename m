Return-Path: <linux-kernel-owner+w=401wt.eu-S1751403AbZHSHEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbZHSHEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 03:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbZHSHEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 03:04:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:42188 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZHSHEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 03:04:15 -0400
Subject: Re: CPU scheduler weirdness?
From: Peter Zijlstra <peterz@infradead.org>
To: Marton Balint <cus@fazekas.hu>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
	 <20090813155812.GA15714@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Aug 2009 09:04:15 +0200
Message-Id: <1250665455.7583.326.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 21:49 +0200, Marton Balint wrote:

> In the meantime, I was able to create a tiny C program which always 
> succesfully reproduces the bug. It's basically an endless loop which does 
> not stop while the process is running on the last CPU core. The program 
> creates multiple instances of itself, to be able to keep all of the CPU 
> cores busy. After 1 second, the processes running on other than the last 
> CPU core die, the processes running on the last CPU core remain stuck 
> there...
> 
> I tested it on my dual core system, if someone could test it on a quad 
> core and report back that would probably be useful.
> 
> Usage: ./schedtest <number of CPU cores>
> 
> And don't forget to kill the stuck processes after using the program! :)

So what's the bug? Sure one task will stay on the cpu, and because there
is no contention it doesn't get migrated, and therefore won't quit,
how's that a problem?

If you start a bunch of loops (enough to fill all cpus) you'll find
it'll get migrated and die pretty quickly.

Those same loops `while :; do :; done &` get spread around the available
cores just fine, still no bug.

btw: sysconf(_SC_NPROCESSORS_ONLN);
