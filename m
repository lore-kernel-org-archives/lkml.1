Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZINPhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZINPhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 11:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbZINPhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 11:37:21 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:40544 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbZINPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 11:37:20 -0400
Date: Mon, 14 Sep 2009 17:37:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, John Stultz <johnstul@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: [crash, bisected] Re: clocksource: Resolve cpu hotplug dead
 lock with TSC unstable
Message-ID: <20090914173720.5774c01f@skybase>
In-Reply-To: <20090914151958.GA17791@elte.hu>
References: <20090909122006.GA18599@kernel.dk>
	<1252565738.7205.29.camel@laptop>
	<20090910065856.GL18599@kernel.dk>
	<20090910073317.GP18599@kernel.dk>
	<20090910074902.GA10634@elte.hu>
	<20090910075357.GT18599@kernel.dk>
	<20090910100214.GB21314@elte.hu>
	<20090910180049.GA10579@elte.hu>
	<20090911073747.GA8209@elte.hu>
	<20090911153305.3fe9a361@skybase>
	<20090914151958.GA17791@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009 17:19:58 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> Now another box crashes during bootup. Reverting these two:
> 
>  f79e025: clocksource: Resolve cpu hotplug dead lock with TSC unstable, fix crash
>  7285dd7: clocksource: Resolve cpu hotplug dead lock with TSC unstable
> 
> allows me to boot it.
> 
> plain 32-bit defconfig.

I've seen the bug report. init_workqueues comes after smp_init.
The idea I'm currently playing with is a simple check in the tsc
code if the tsc clocksource is already registered or not.
When smp_init is called the tsc is not yet registered, we could
just set the rating to zero.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

