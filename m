Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZIKTsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZIKTsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZIKTsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:48:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:41647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbZIKTsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:48:03 -0400
Date: Fri, 11 Sep 2009 21:51:31 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "John Stoffel" <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, peterz@infradead.org,
       yanmin_zhang@linux.intel.com, torvalds@linux-foundation.org,
       jens.axboe@oracle.com
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-ID: <20090911215131.67d9f39f@infradead.org>
In-Reply-To: <19114.41505.479086.782442@stoffel.org>
References: <20090911174019.1ed02737@infradead.org>
	<19114.41505.479086.782442@stoffel.org>
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

On Fri, 11 Sep 2009 15:16:49 -0400
"John Stoffel" <john@stoffel.org> wrote:

> >>>>> "Arjan" == Arjan van de Ven <arjan@infradead.org> writes:
> 
> Arjan> From: Arjan van de Ven <arjan@linux.intel.com>
> Arjan> Subject: [PATCH] cpuidle: A new variant of the menu governor
> 
> Arjan> This patch adds a new idle governor which balances power
> Arjan> savings, energy efficiency and performance impact.
> 
> Arjan> The reason for a reworked governor is that there have been
> Arjan> serious performance issues reported with the existing code
> Arjan> on Nehalem server systems.
> 
> Arjan> To show this I'm sure Andrew wants to see benchmark results:
> Arjan> (benchmark is "fio", "no cstates" is using "idle=poll")
> 
> Arjan> 		no cstates	current linux	new
> Arjan> algorithm 1 disk		107 Mb/s	85
> Arjan> Mb/s		105 Mb/s 2 disks		215
> Arjan> Mb/s	123 Mb/s	209 Mb/s 12 disks	590
> Arjan> Mb/s	320 Mb/s	585 Mb/s
> 
> Don't you need another row or three where you show a) how much time
> each test took, and b) how much (or average) power used for the
> duration of the test?  
> 
> I'm just curious if the new algorithm (or even the current one!) saves
> any appreciable power over the 'no cstates' case.  It's not clear what
> the savings are.  

if you don't do C states your cpu is likely using 50 Watts more power.
not an option in general.

> 
> Also, latency in terms of switching to higher power and then back down
> would be nice to see.

these are C states not P states.


latency depends on the cpu; this is exposed in sysfs;
tends to be for the deepest C state in the 80 to 200 usec range.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
