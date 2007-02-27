Return-Path: <linux-kernel-owner+w=401wt.eu-S1751354AbXB0AoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbXB0AoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbXB0AoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:44:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbXB0AoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:44:22 -0500
Message-ID: <45E37EA3.3060101@redhat.com>
Date: Mon, 26 Feb 2007 19:43:15 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: hyoshiok@miraclelinux.com
CC: Dave Jones <davej@redhat.com>, Pete Harlan <harlan@artselect.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan>	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>	 <20070226220401.GA22363@artselect.com>	 <20070226223645.GA24174@redhat.com> <98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
In-Reply-To: <98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hiro Yoshioka wrote:
> Howdy,
> 
> MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
> http://ossipedia.ipa.go.jp/capacity/EV0612260303/
> (written in Japanese but you may read the graph. We compared
> 5.0.24 vs 5.0.32)
> 
> The following is oprofile data
> ==> 
> cpu=8-mysql=5.0.32-gcc=3.4/oprofile-eu=2200-op=default-none/opreport-l.txt
> <==
> CPU: Core Solo / Duo, speed 2666.76 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Unhalted clock cycles) with a unit
> mask of 0x00 (Unhalted core cycles) count 100000
> samples  %        app name                 symbol name
> 47097502 16.8391  libpthread-2.3.4.so      pthread_mutex_trylock
> 19636300  7.0207  libpthread-2.3.4.so      pthread_mutex_unlock
> 18600010  6.6502  mysqld                   rec_get_offsets_func
> 18121328  6.4790  mysqld                   btr_search_guess_on_hash
> 11453095  4.0949  mysqld                   row_search_for_mysql
> 
> MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
> machine.
> 
> I think there are a lot of room to be inproved in MySQL implementation.

That's one aspect.

The other aspect of the problem is that when the number of
threads exceeds the number of CPU cores, Linux no longer
manages to keep the CPUs busy and we get a lot of idle time.

On the other hand, with the number of threads being equal to
the number of CPU cores, we are 100% CPU bound...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
