Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZKEOz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZKEOz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbZKEOzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:55:25 -0500
Received: from www.tglx.de ([62.245.132.106]:47979 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758050AbZKEOzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:55:22 -0500
Date: Thu, 5 Nov 2009 15:54:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
In-Reply-To: <20091105141055.GA17350@redhat.com>
Message-ID: <alpine.LFD.2.00.0911051547110.12138@localhost.localdomain>
References: <6417.1257351084@turing-police.cc.vt.edu> <200911051941.03401.rusty@rustcorp.com.au> <20091105141055.GA17350@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009, Oleg Nesterov wrote:
> > Oleg (CC'd) made workqueues use cpu_maps_update_begin() instead of the
> > more obvious get_online_cpus() in 3da1c84c00c7e5f.  Reverting that seems like
> > a bad idea.
> 
> Even if create_workueue() used get_online_cpus() instead of cpu_add_remove_lock,
> we have the same problem: _cpu_up() takes cpu_hotplug.lock which is needed for
> get_online_cpus(). The dependency above becomes:
> 
> 	cpu_up()->clocksource_change_rating() takes clocksource_mutex under
> 	cpu_hotplug.lock (cpu_hotplug_begin)
> 
> 	clocksource_done_booting()->create_workueue() takes cpu_hotplug.lock
> 	(get_online_cpus) under clocksource_mutex

Hmm, we fixed all this lock madness in mainline already.
clocksource_done_booting() does not longer call
create_workqueue(). How got this code reverted in motm ?

Thanks,

	tglx
