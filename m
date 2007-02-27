Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXB0AcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXB0AcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:32:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbXB0AcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:32:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:55586 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXB0AcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:32:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iZi8rF91EoORboTiF1/xvO4oLmoX/W5o7ocx3oWdWkl+T79hcV08BbPOfXRq2z8MFpgW+083Bl6TYoJltd/OC30o1kgQVR02M7f7toumVZppdJmktgb0XIjdBpsViTDkP7PSKYeJzTatUPIxM2MGLJ5qNqKUlK9LsgN3bU81lNc=
Message-ID: <98df96d30702261632u7479c9b2sce93f80f68bbc8d0@mail.gmail.com>
Date: Tue, 27 Feb 2007 09:32:09 +0900
From: "Hiro Yoshioka" <lkml.hyoshiok@gmail.com>
Reply-To: hyoshiok@miraclelinux.com
To: "Dave Jones" <davej@redhat.com>, "Pete Harlan" <harlan@artselect.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Rik van Riel" <riel@redhat.com>,
       "Lorenzo Allegrucci" <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
Cc: "Hiro Yoshioka" <hyoshiok@miraclelinux.com>
In-Reply-To: <20070226223645.GA24174@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172425476.5489.11.camel@odyssey.lan>
	 <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au>
	 <20070226220401.GA22363@artselect.com>
	 <20070226223645.GA24174@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

MySQL 5.0.26 had some scalability issues and it solved since 5.0.32
http://ossipedia.ipa.go.jp/capacity/EV0612260303/
(written in Japanese but you may read the graph. We compared
5.0.24 vs 5.0.32)

The following is oprofile data
==> cpu=8-mysql=5.0.32-gcc=3.4/oprofile-eu=2200-op=default-none/opreport-l.txt
<==
CPU: Core Solo / Duo, speed 2666.76 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Unhalted clock cycles) with a unit
mask of 0x00 (Unhalted core cycles) count 100000
samples  %        app name                 symbol name
47097502 16.8391  libpthread-2.3.4.so      pthread_mutex_trylock
19636300  7.0207  libpthread-2.3.4.so      pthread_mutex_unlock
18600010  6.6502  mysqld                   rec_get_offsets_func
18121328  6.4790  mysqld                   btr_search_guess_on_hash
11453095  4.0949  mysqld                   row_search_for_mysql

MySQL tries to get a mutex but it spends about 16.8% of CPU on 8 core
machine.

I think there are a lot of room to be inproved in MySQL implementation.

On 2/27/07, Dave Jones <davej@redhat.com> wrote:
> On Mon, Feb 26, 2007 at 04:04:01PM -0600, Pete Harlan wrote:
>  > On Tue, Feb 27, 2007 at 12:36:04AM +1100, Nick Piggin wrote:
>  > > I found a couple of interesting issues so far. Firstly, the MySQL
>  > > version that I'm using (5.0.26-Max) is making lots of calls to
>  >
>  > FYI, MySQL fixed some scalability problems in version 5.0.30, as
>  > mentioned here:
>  >
>  > http://www.mysqlperformanceblog.com/2007/01/03/innodb-benchmarks/
>  >
>  > It may be worth using more recent sources than 5.0.26 if tracking down
>  > scaling problems in MySQL.
>
> The blog post that originated this discussion ran tests on 5.0.33
> Not that the mysql version should really matter. The key point here
> is that FreeBSD and Linux were running the *same* version, and
> FreeBSD was able to handle the situation better somehow.
>
>                 Dave
>
> --
> http://www.codemonkey.org.uk
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
  Hiro
-- 
Hiro Yoshioka
mailto:hyoshiok at miraclelinux.com
