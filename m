Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXCKSJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXCKSJd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933919AbXCKSJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:09:32 -0400
Received: from [212.12.190.130] ([212.12.190.130]:32875 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S933918AbXCKSJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:09:31 -0400
From: Al Boldi <a1426z@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Sun, 11 Mar 2007 21:11:38 +0300
User-Agent: KMail/1.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <1173170554.5835.385.camel@frg-rhel40-em64t-03> <200703061815.16702.a1426z@gawab.com>
In-Reply-To: <200703061815.16702.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_aZE9F+nRETMtP0Y"
Message-Id: <200703112111.38415.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Boundary-00=_aZE9F+nRETMtP0Y
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Al Boldi wrote:
> BTW, another way to show these hickups would be through some kind of a
> cpu/proc timing-tracer.  Do we have something like that?

Here is something like a tracer.

Original idea by Chris Friesen, thanks, from this post:
http://marc.theaimsgroup.com/?l=linux-kernel&m=117331003029329&w=4

Try attached chew.c like this:
Boot into /bin/sh.
Run chew in one console.
Run nice chew in another console.
Watch timings.

Console 1: ./chew
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    5 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    6 ms
pid 655, prio   0, out for    5 ms

Console 2: nice -10 ./chew
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    5 ms
pid 669, prio  10, out for   65 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    5 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    5 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for   65 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms
pid 669, prio  10, out for    6 ms

Console 2: nice -15 ./chew
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for   95 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for   95 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for   95 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for   95 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    5 ms
pid 673, prio  15, out for    6 ms
pid 673, prio  15, out for    5 ms

Console 2: nice -18 ./chew
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    6 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    6 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    5 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    6 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    5 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    5 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    5 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    6 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    6 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    5 ms
pid 677, prio  18, out for  113 ms
pid 677, prio  18, out for    5 ms

Console 2: nice -19 ./chew
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms
pid 679, prio  19, out for  119 ms

Now with negative nice:
Console 1: ./chew
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for  125 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for    6 ms
pid 674, prio   0, out for    5 ms
pid 674, prio   0, out for  110 ms

Console 2: nice --20 ./chew
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    5 ms
pid 687, prio -20, out for    6 ms
pid 687, prio -20, out for    6 ms


OTOH, mainline is completely smooth, albeit huge drop-outs.


Thanks!

--
Al



--Boundary-00=_aZE9F+nRETMtP0Y
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="chew.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="chew.c"

/*
 * orignal idea by Chris Friesen.  Thanks.
 */

#include <stdio.h>
#include <sys/time.h>
#include <sys/resource.h>

#define THRESHOLD_USEC 2000

unsigned long long stamp()
{
        struct timeval tv;
        gettimeofday(&tv, 0);
        return (unsigned long long) tv.tv_usec + ((unsigned long long) tv.tv_sec)*1000000;
}

int main()
{
        unsigned long long thresh_ticks = THRESHOLD_USEC;
        unsigned long long cur,last;
        struct timespec ts;

        sched_rr_get_interval(0, &ts);
        printf("pid %d, prio %3d, interval of %d nsec\n", getpid(), getpriority(PRIO_PROCESS, 0), ts.tv_nsec);

        last = stamp();
        while(1) {
                cur = stamp();
                unsigned long long delta = cur-last;
                if (delta > thresh_ticks) {
                        printf("pid %d, prio %3d, out for %4llu ms\n", getpid(), getpriority(PRIO_PROCESS, 0), delta/1000);
                        cur = stamp();
                }
                last = cur;
        }

        return 0;
}

--Boundary-00=_aZE9F+nRETMtP0Y--

