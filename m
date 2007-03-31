Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbXCaCgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbXCaCgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXCaCgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:36:18 -0400
Received: from web26704.mail.ukl.yahoo.com ([217.146.176.67]:45714 "HELO
	web26704.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933404AbXCaCgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:36:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.gr;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=GQhndAlcts+DOfYnID9WjzS1pwBZQiNOpzD0SeejzZLjjYT6Xs1QtY6fdg1Xje9/GIwkbQPSG7RpxEKGK/kaCIQbnlaeXZ9JE6HI6JWPTn9aXJFqzCdVSAGHVfU8eyTWcDRY8Vz13Arq6yfS6XoRnt8UsUXHuImIp2V5CkV0X7w=  ;
Message-ID: <20070331023615.98478.qmail@web26704.mail.ukl.yahoo.com>
X-YMail-OSG: le_Io_wVM1noboiCoq4e6.XFRKAKH3E79l.wJz6iaSDwFHSfnMIWOwDPQ3qmnnd.x2oxlcJrrCXJRTBG1mwsHj.3oNxTlB3EZR_mWmJHcYtFbceh
Date: Fri, 30 Mar 2007 19:36:14 -0700 (PDT)
From: Xenofon Antidides <xantidides@yahoo.gr>
Subject: Re: [test] hackbench.c interactivity results: vanilla versus SD/RSDL
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1175273215.7185.3.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-401369239-1175308574=:95191"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-401369239-1175308574=:95191
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline


--- Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2007-03-30 at 15:05 +0000, Xenofon Antidides
> wrote:
> > ----- Original Message ----
> > From: Ingo Molnar <mingo@elte.hu>
> > To: Con Kolivas <kernel@kolivas.org>
> > Cc: linux list <linux-kernel@vger.kernel.org>;
> Andrew Morton <akpm@linux-foundation.org>; Mike
> Galbraith <efault@gmx.de>
> > Sent: Thursday, March 29, 2007 9:22:49 PM
> > Subject: [test] hackbench.c interactivity results:
> vanilla versus SD/RSDL
> > 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Con Kolivas <kernel@kolivas.org> wrote:
> > > 
> > > > I'm cautiously optimistic that we're at the
> thin edge of the bugfix 
> > > > wedge now.
> > [...]
> > 
> > > and the numbers he posted:
> > > 
> > > 
>
http://marc.info/?l=linux-kernel&m=117448900626028&w=2
> > 
> > We been staring at these numbers for while now and
> we come to the conclusion they wrong.
> > 
> > The test is f is 3 tasks, two on different and one
> on same cpu as sh here:
> > virgin 2.6.21-rc3-rsdl-smp
> > top - 13:52:50 up 7 min, 12 users,  load average:
> 3.45, 2.89, 1.51
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM
>    TIME+  P COMMAND
> >  6560 root      31   0  2892 1236 1032 R   82  0.1
>   1:50.24 1 sh
> >  6558 root      28   0  1428  276  228 S   42  0.0
>   1:00.09 1 f
> >  6557 root      30   0  1424  280  228 R   35  0.0
>   1:00.25 0 f
> >  6559 root      39   0  1424  276  228 R   33  0.0
>   0:58.36 0 f
> 
> This is a 1 second sample, tasks migrate.
> 
> 	-Mike

Something different on many cpus? Sorry I was thinking
something other. I try 50% run + 50% sleep on one cpu
and mainline has big problem. Sorry for bad code I
copy bits to make it work. Start program first then
run bash 100% cpu (while : ; do : ; done). Try change
program forks from 1 till 3 or more mainline kernel
and bash gets 0%.



Xant


 
____________________________________________________________________________________
Get your own web address.  
Have a HUGE year through Yahoo! Small Business.
http://smallbusiness.yahoo.com/domains/?p=BESTDEAL
--0-401369239-1175308574=:95191
Content-Type: text/x-csrc; name="fiftyp.c"
Content-Description: 1949799762-fiftyp.c
Content-Disposition: inline; filename="fiftyp.c"

// gcc -O2 -o fiftyp fiftyp.c -lrt
// code from interbench.c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
int forks=1;
int runus,sleepus=7000;
unsigned long loops_per_ms;
void terminal_error(const char *name)
{
	fprintf(stderr, "\n");
	perror(name);
	exit (1);
}

unsigned long long get_nsecs(struct timespec *myts)
{
	if (clock_gettime(CLOCK_REALTIME, myts))
		terminal_error("clock_gettime");
	return (myts->tv_sec * 1000000000 + myts->tv_nsec );
}

void burn_loops(unsigned long loops)
{
	unsigned long i;

	/*
	 * We need some magic here to prevent the compiler from optimising
	 * this loop away. Otherwise trying to emulate a fixed cpu load
	 * with this loop will not work.
	 */
	for (i = 0 ; i < loops ; i++)
	     asm volatile("" : : : "memory");
}

/* Use this many usecs of cpu time */
void burn_usecs(unsigned long usecs)
{
	unsigned long ms_loops;

	ms_loops = loops_per_ms / 1000 * usecs;
	burn_loops(ms_loops);
}

void microsleep(unsigned long long usecs)
{
	struct timespec req, rem;

	rem.tv_sec = rem.tv_nsec = 0;

	req.tv_sec = usecs / 1000000;
	req.tv_nsec = (usecs - (req.tv_sec * 1000000)) * 1000;
continue_sleep:
	if ((nanosleep(&req, &rem)) == -1) {
		if (errno == EINTR) {
			if (rem.tv_sec || rem.tv_nsec) {
				req.tv_sec = rem.tv_sec;
				req.tv_nsec = rem.tv_nsec;
				goto continue_sleep;
			}
			goto out;
		}
		terminal_error("nanosleep");
	}
out:
	return;
}

/*
 * In an unoptimised loop we try to benchmark how many meaningless loops
 * per second we can perform on this hardware to fairly accurately
 * reproduce certain percentage cpu usage
 */
void calibrate_loop(void)
{
	unsigned long long start_time, loops_per_msec, run_time = 0;
	unsigned long loops;
	struct timespec myts;

	loops_per_msec = 1000000;
redo:
	/* Calibrate to within 1% accuracy */
	while (run_time > 1010000 || run_time < 990000) {
		loops = loops_per_msec;
		start_time = get_nsecs(&myts);
		burn_loops(loops);
		run_time = get_nsecs(&myts) - start_time;
		loops_per_msec = (1000000 * loops_per_msec / run_time ? :
			loops_per_msec);
	}

	/* Rechecking after a pause increases reproducibility */
	sleep(1);
	loops = loops_per_msec;
	start_time = get_nsecs(&myts);
	burn_loops(loops);
	run_time = get_nsecs(&myts) - start_time;

	/* Tolerate 5% difference on checking */
	if (run_time > 1050000 || run_time < 950000)
		goto redo;
 loops_per_ms=loops_per_msec;
 sleep(1);
 start_time=get_nsecs(&myts);
 microsleep(sleepus);
 run_time=get_nsecs(&myts)-start_time;
 runus=run_time/1000;
}

int main(void){
 int i;
 calibrate_loop();
 printf("starting %d forks\n",forks);
 for(i=1;i<forks;i++){
  if(!fork())
   break;
 }
 while(1){
  burn_usecs(runus);
  microsleep(sleepus);
 }
 return 0;
}

--0-401369239-1175308574=:95191--
