Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbXIQLS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbXIQLS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbXIQLSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:18:50 -0400
Received: from mail001.aei.ca ([206.123.6.130]:52339 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbXIQLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:18:49 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 07:18:49 EDT
From: Ed Tomlinson <edt@aei.ca>
To: "Rob Hussey" <robjhussey@gmail.com>
Subject: Re: Scheduler benchmarks - a follow-up
Date: Mon, 17 Sep 2007 07:12:02 -0400
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, efault@gmx.de, a.p.zijlstra@chello.nl,
       zippel@linux-m68k.org, linux-kernel@vger.kernel.org, ck@vds.kolivas.org
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
In-Reply-To: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709170712.03679.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

I gather this was with the complete -ck patchset?  It would be interesting to see if just SD
performed as well.  If it does, CFS needs more work. if not there are other things in -ck
that really do improve performance and should be looked into.

Thanks
Ed Tomlinson

On September 17, 2007, Rob Hussey wrote:
> Hi all,
> 
> After posting some benchmarks involving cfs
> (http://lkml.org/lkml/2007/9/13/385), I got some feedback, so I
> decided to do a follow-up that'll hopefully fill in the gaps many
> people wanted to see filled.
> 
> This time around I've done the benchmarks against 2.6.21, 2.6.22-ck1,
> and 2.6.23-rc6-cfs-devel (latest git as of 12 hours ago). All three
> .configs are attached. The benchmarks consist of lat_ctx and
> hackbench, both with a growing number of processes, as well as
> pipe-test. All benchmarks were also run bound to a single core.
> 
> Since this time there are hundreds of lines of data, I'll post a
> reasonable amount here and attach the data files. There are graphs
> again this time, which I'll post links to as well as attach.
> 
> I'll start with some selected numbers, which are preceded by the
> command used for the benchmark.
> 
> for((i=2; i < 201; i++)); do lat_ctx -s 0 $i; done:
> (the left most column is the number of processes ($i))
> 
> 	2.6.21		2.6.22-ck1	2.6.23-rc6-cfs-devel
> 
> 15	5.88		4.85		5.14
> 16	5.80		4.77		4.76
> 17	5.91		4.84		4.92
> 18	5.79		4.86		4.83
> 19	5.89		4.94		4.93
> 20	5.78		4.81		5.13
> 21	5.88		5.02		4.94
> 22	5.79		4.79		4.84
> 23	5.93		4.86		5.05
> 24	5.73		4.76		4.90
> 25	6.00		4.94		5.19
> 
> for((i=1; i < 100; i++)); do hackbench $i; done:
> 
> 	2.6.21  	2.6.22-ck1	2.6.23-rc6-cfs-devel
> 
> 80	9.75		 8.95		 9.52
> 81	11.54		8.87		9.57
> 82	11.29		8.92		9.67
> 83	10.76		8.96		9.82
> 84	12.04		9.20		9.91
> 85	11.74		9.39		10.09
> 86	12.01		9.37		10.18
> 87	11.39		9.43		10.13
> 88	12.48		9.60		10.38
> 89	11.85		9.77		10.52
> 90	13.78		9.76		10.65
> 
> pipe-test:
> (the left most column is the run #)
> 
> 	2.6.21	2.6.22-ck1	2.6.23-rc6-cfs-devel
> 
> 1	13.84	12.59		13.01
> 2	13.90 	12.57 		13.00
> 3	13.84 	12.62 		13.06
> 4	13.87 	12.61 		13.04
> 5	13.82 	12.62 		13.03
> 6	13.86 	12.60 		13.02
> 7	13.85 	12.61 		13.02
> 8 	13.88 	12.45 		13.04
> 9	13.83 	12.46 		13.03
> 10	13.88 	12.46 		13.03
> 
> Bound to Single core:
> 
> for((i=2; i < 201; i++)); do lat_ctx -s 0 $i; done:
> 
> 		2.6.21		2.6.22-ck1	2.6.23-rc6-cfs-devel
> 
> 15		2.90		2.76		2.21
> 16		2.88		2.79		2.36
> 17		2.87		2.77		2.52
> 18		2.86		2.78		2.66
> 19		2.89		2.72		2.81
> 20		2.87		2.72		2.95
> 21		2.86		2.69		3.10
> 22		2.88		2.72		3.26
> 23		2.86		2.71		3.39
> 24		2.84		2.72		3.56
> 25		2.82		2.73		3.72
> 
> 
> for((i=1; i < 100; i++)); do hackbench $i; done:
> 
> 		2.6.21		2.6.22-ck1	2.6.23-rc6-cfs-devel
> 
> 80		14.29		10.86		12.03
> 81		14.40		11.25		12.17
> 82		15.00		11.42		12.33
> 83		14.87		11.12		12.51
> 84		15.37		11.42		12.66
> 85		15.75		11.68		12.79
> 86		15.64		11.95		12.95
> 87		15.80		11.64		13.12
> 88		15.70		11.91		13.25
> 89		15.10		12.19		13.42
> 90		16.24		12.53		13.54
> 
> pipe-test:
> 
> 	2.6.21	2.6.22-ck1	2.6.23-rc6-cfs-devel
> 
> 1  	9.27	8.50 		8.55
> 2  	9.27	8.47 		8.55
> 3  	9.28	8.47 		8.54
> 4  	9.28	8.48 		8.54
> 5  	9.28	8.48 		8.54
> 6  	9.29	8.46 		8.54
> 7  	9.28	8.47 		8.55
> 8  	9.29	8.47 		8.55
> 9  	9.29	8.45 		8.54
> 10 	9.28	8.46 		8.54
> 
> Links to the graphs (the .dat files are in the same directory):
> http://www.healthcarelinen.com/misc/benchmarks/lat_ctx_benchmark2.png
> http://www.healthcarelinen.com/misc/benchmarks/hackbench_benchmark2.png
> http://www.healthcarelinen.com/misc/benchmarks/pipe-test_benchmark2.png
> http://www.healthcarelinen.com/misc/benchmarks/BOUND_lat_ctx_benchmark2.png
> http://www.healthcarelinen.com/misc/benchmarks/BOUND_hackbench_benchmark2.png
> http://www.healthcarelinen.com/misc/benchmarks/BOUND_pipe-test_benchmark2.png
> 
> The only analysis I'll offer is that both sd and cfs are improvements,
> and I'm glad that there is a lot of work being done in this area of
> linux development. Much respect to Con Kolivas, Ingo Molnar, and Roman
> Zippel, as well all the others who have contributed.
> 
> Any feedback is welcome.
> 
> Regards,
> Rob
> 


