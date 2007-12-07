Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbXLGOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbXLGOeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbXLGOe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:34:27 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54683 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbXLGOe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:34:27 -0500
Date: Fri, 7 Dec 2007 15:27:41 +0100
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Stefano Brivio <stefano.brivio@polimi.it>, Robert Love <rml@tech9.net>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] x86: scale cyc_2_nsec according to CPU frequency
Message-ID: <20071207152741.3408aeef@inria.fr>
In-Reply-To: <20071207135525.GA5588@elte.hu>
References: <20071207021952.6f0ac922@morte>
	<alpine.LFD.0.99999.0712070646210.3221@localhost.localdomain>
	<3d8471ca0712062318j483f8be6h256778752a13639a@mail.gmail.com>
	<20071207090252.1caf1509@inria.fr>
	<20071207135525.GA5588@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 7 Dec 2007 14:55:25 +0100,
Ingo Molnar <mingo@elte.hu> a écrit :

> Firstly, we dont need the 'offset' anymore because cpu_clock() maintains 
> offsets itself.

Yes, but a lower quality one. __update_rq_clock tries to compensate
large jumping clocks with a jiffy resolution, while my offset arranges
for a very smooth frequency transition.

I agree with keeping a single offset, but I liked the fact that with my
patch on frequency change, the clock had no jump at all.

> + *  ns += offset to avoid sched_clock jumps with cpufreq

I guess this needs to go away if I don't make my point :-(

> +	printk("CPU#%d: changed cyc2ns scale from %ld to %ld\n",
> +		cpu, prev_scale, *scale);

Pointing it out just to be sure it does not end in the final version ;-)

Thanks for cleaning up my mess ;-)

-- 
Guillaume
