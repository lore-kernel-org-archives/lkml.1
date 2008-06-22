Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYFVURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYFVURl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbYFVURc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 16:17:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:60056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYFVURb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 16:17:31 -0400
Date: Sun, 22 Jun 2008 13:17:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, josh@freedesktop.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, dino@in.ibm.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       vegard.nossum@gmail.com, adobriyan@gmail.com, oleg@tv-sign.ru,
       bunk@kernel.org, rjw@sisk.pl
Subject: Re: [PATCH -tip-rcu] Make rcutorture more vicious: make quiescent
 rcutorture less power-hungry
Message-ID: <20080622131712.54ba732c@infradead.org>
In-Reply-To: <20080622200638.GA25328@linux.vnet.ibm.com>
References: <20080618122144.GA27143@linux.vnet.ibm.com>
	<20080618162649.GA18326@linux.vnet.ibm.com>
	<20080622200638.GA25328@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 13:06:38 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> This patch makes the non-module rcutorture a bit more friendly to
> the power-conservation code.  This is a rather simple-minded approach.
> More sophisticated approaches would get rid of the rcutorture tasks
> while rcutorture execution was suppressed, but attempts thus far to
> do this have not gone well -- calling rcu_torture_init() from a /proc
> callout results in oopses.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcutorture.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff -urpNa -X dontdiff
> linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c
> linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c ---
> linux-2.6.26-rc4-rcut2-proc/kernel/rcutorture.c	2008-06-22
> 10:29:04.000000000 -0700 +++
> linux-2.6.26-rc4-rcut3-procq/kernel/rcutorture.c	2008-06-22
> 12:20:10.000000000 -0700 @@ -196,7 +196,10 @@ static void
> rcu_stutter_wait(void) { while (stutter_pause_test
> || !rcutorture_runnable)
> -		schedule_timeout_interruptible(1);
> +		if (rcutorture_runnable)
> +			schedule_timeout_interruptible(1);
> +		else
> +			schedule_timeout_interruptible(HZ);
>  }

could you also make it use round_jiffies_relative() to make the power
impact even less.....
(by coalescing various "once a second" timers like this)



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
