Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbZGVQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbZGVQCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZGVQCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:02:52 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:35422 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZGVQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:02:51 -0400
Date: Wed, 22 Jul 2009 18:02:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [RFC][PATCH] cache __next_timer_interrupt result
Message-ID: <20090722180248.57e31f20@skybase>
In-Reply-To: <alpine.LFD.2.00.0907221632090.2813@localhost.localdomain>
References: <20090721202505.7d56a079@skybase>
	<alpine.LFD.2.00.0907221632090.2813@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 16:38:18 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 21 Jul 2009, Martin Schwidefsky wrote:
> 
> > From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> > 
> > Each time a cpu goes to sleep on a NOHZ=y system the timer wheel is
> > searched for the next timer interrupt. It can take quite a few cycles
> > to find the next pending timer. This patch adds a field to tvec_base
> > that caches the result of __next_timer_interrupt. The hit ratio is
> > around 80% on my thinkpad under normal use, on a server I've seen
> 
> Nice, I like it.

Thanks :-)
 
> > hit ratios from 5% to 95% dependent on the workload.
> 
> Which workloads result in lower hit ratios ? Heavy networking ?

5% ping-pong packet over loopback between two cpus. So yes, networking.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

