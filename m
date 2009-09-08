Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZIHPp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZIHPp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 11:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZIHPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 11:45:25 -0400
Received: from bu3sch.de ([62.75.166.246]:54258 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZIHPpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 11:45:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Tue, 8 Sep 2009 17:45:18 +0200
User-Agent: KMail/1.9.9
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
References: <20090906205952.GA6516@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu>
In-Reply-To: <20090907205701.GA8590@elte.hu>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909081745.21091.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 September 2009 22:57:01 Ingo Molnar wrote:
> 
> * Michael Buesch <mb@bu3sch.de> wrote:
> 
> > On Monday 07 September 2009 20:26:29 Ingo Molnar wrote:
> > > Could you profile it please? Also, what's the context-switch rate?
> > 
> > As far as I can tell, the broadcom mips architecture does not have 
> > profiling support. It does only have some proprietary profiling 
> > registers that nobody wrote kernel support for, yet.
> 
> Well, what does 'vmstat 1' show - how many context switches are 
> there per second on the iperf server? In theory if it's a truly 
> saturated box, there shouldnt be many - just a single iperf task 
> running at 100% CPU utilization or so.
> 
> (Also, if there's hrtimer support for that board then perfcounters 
> could be used to profile it.)

CFS:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0      0  15892   1684   5868    0    0     0     0  268    6 31 69  0  0
 1  0      0  15892   1684   5868    0    0     0     0  266    2 34 66  0  0
 1  0      0  15892   1684   5868    0    0     0     0  266    6 33 67  0  0
 1  0      0  15892   1684   5868    0    0     0     0  267    4 37 63  0  0
 1  0      0  15892   1684   5868    0    0     0     0  267    6 34 66  0  0
[  4] local 192.168.1.1 port 5001 connected with 192.168.1.99 port 47278
 2  0      0  15756   1684   5868    0    0     0     0 1655   68 26 74  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1945   88 20 80  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1882   85 20 80  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1923   86 18 82  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1986   87 23 77  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1923   87 17 83  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1951   84 19 81  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1970   87 18 82  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1972   85 23 77  0  0
 2  0      0  15756   1684   5868    0    0     0     0 1961   87 18 82  0  0
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  28.6 MBytes  23.9 Mbits/sec
 1  0      0  15752   1684   5868    0    0     0     0  599   22 22 78  0  0
 1  0      0  15752   1684   5868    0    0     0     0  269    4 32 68  0  0
 1  0      0  15752   1684   5868    0    0     0     0  266    4 29 71  0  0
 1  0      0  15764   1684   5868    0    0     0     0  267    6 37 63  0  0
 1  0      0  15764   1684   5868    0    0     0     0  267    4 31 69  0  0
 1  0      0  15768   1684   5868    0    0     0     0  266    4 51 49  0  0


I'm currently unable to test BFS, because the device throws strange flash errors.
Maybe the flash is broken :(

-- 
Greetings, Michael.
