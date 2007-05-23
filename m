Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbXEWH63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbXEWH63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 03:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbXEWH6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 03:58:21 -0400
Received: from hermes2.dur.ac.uk ([129.234.8.21]:49864 "EHLO hermes2.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbXEWH6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 03:58:20 -0400
Date: Wed, 23 May 2007 08:57:17 +0100
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: ck@vds.kolivas.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: swap prefetch improvements
Message-Id: <20070523085717.adbd992f.thatistosayiseenem@gawab.com>
In-Reply-To: <200705230850.01844.kernel@kolivas.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<200705222037.54741.kernel@kolivas.org>
	<20070522214222.8b197247.thatistosayiseenem@gawab.com>
	<200705230850.01844.kernel@kolivas.org>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 08:50:01 +1000
Con Kolivas <kernel@kolivas.org> wrote:

> On Wednesday 23 May 2007 06:42, Ash Milsted wrote:
> > Hi. I just did some video encoding on my desktop and I was noticing
> > (for the first time in a while) that running apps had to hit swap quite
> > a lot when I switched to them (the encoding was going at full blast for
> > most of the day, and most of the time other running apps were
> > idle). Now, a good half of my RAM appeared to be free during all this,
> > so I was thinking at the time that it would be nice if swap prefetch
> > could be tunably more aggressive. I guess it would be ideal in this
> > case if it could kick in during tunably low disk-IO periods, even if
> > the CPU is rather busy. I'm sure you've considered this, so I only butt
> > in here to cast a vote for it. :)
> 
> In this case nicing the video encode should be enough to make it prefetch even 
> during heavy cpu usage. It detects the total nice level rather than the cpu 
> usage.
> 

Cunning, but I guess the regular (less than 5 seconds apart)
reads/writes during the encoding process would cause prefetching to
hold off, no? I had used nice and ionice to reduce the encoder
priority, which made desktop apps pretty responsive, except when they
had to hit swap. If swap prefetch is using the idle io-priority I
suppose it would hardly affect performance if it kicked in during such
use, since it would operate in between the encoder reads anyway
(assuming the encoder is at higher ioprio), right ?

> 
> I plan to make it prefetch more aggressively by default soon and make it more 
> tunable too.
> 

'Sounds good!
