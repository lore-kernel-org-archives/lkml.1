Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYIMLpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYIMLpJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 07:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYIMLo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 07:44:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:58437 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750704AbYIMLo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 07:44:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Jzk0JjWMJkoAWwBIvgcHeU2jJrS0GCN7nLaKd3G
	B73NXBmFVAD/gj
Subject: Re: [Bug #11308] tbench regression on each kernel release from 
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <48CAE7A0.8000004@linux-foundation.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik>  <48CAE7A0.8000004@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 13 Sep 2008 13:44:47 +0200
Message-Id: <1221306287.5213.111.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-09-12 at 17:05 -0500, Christoph Lameter wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
> > Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
> > Submitter	: Christoph Lameter <cl@linux-foundation.org>
> > Date		: 2008-08-11 18:36 (33 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
> > 
> > 
> > 
> 
> tbench
> 
> 2.6.27-rc6	2760 MB/sec
> 2.6.22 		3235.47 MB/sec

Numbers from my Q6600 Aldi supermarket box (hm, your box is from different shelf)

tbench -t 60 4 localhost followed by 4 60s netperf TCP_RR pairs, each pair
jabbering on a separate port and affine to a separate CPU.  Configs are
as close as I can make them, all kernels built and tested today by
identical userland.

2.6.22.19
Throughput 1136.02 MB/sec 4 procs

16384  87380  1        1       60.01    94179.12
16384  87380  1        1       60.01    88780.61
16384  87380  1        1       60.01    91057.72
16384  87380  1        1       60.01    94242.16

2.6.22.19-cfs-v24.1  (identical config)
Throughput 1126.79 MB/sec 4 procs

16384  87380  1        1       60.00    88809.14
16384  87380  1        1       60.00    89971.25
16384  87380  1        1       60.01    89452.91
16384  87380  1        1       60.01    89478.63

2.6.23.17
Throughput 1073.2 MB/sec 4 procs

16384  87380  1        1       60.00    83635.61
16384  87380  1        1       60.00    82754.36
16384  87380  1        1       60.00    84594.59
16384  87380  1        1       60.00    82995.81

2.6.23.17-cfs-v24.1  (identical config)
Throughput 1145.28 MB/sec 4 procs

16384  87380  1        1       60.00    90278.55
16384  87380  1        1       60.01    90579.31
16384  87380  1        1       60.01    89412.14
16384  87380  1        1       60.00    90270.97

2.6.24.7
Throughput 1119.28 MB/sec 4 procs

16384  87380  1        1       60.00    84092.78
16384  87380  1        1       60.00    84120.68
16384  87380  1        1       60.00    84076.73
16384  87380  1        1       60.00    83995.07

2.6.25.17
Throughput 1113.82 MB/sec 4 procs

16384  87380  1        1       60.00    84629.98
16384  87380  1        1       60.00    84776.38
16384  87380  1        1       60.00    84356.49
16384  87380  1        1       60.00    84469.71

2.6.26.5
Throughput 1095.26 MB/sec 4 procs

16384  87380  1        1       60.00    84481.11
16384  87380  1        1       60.00    84604.38
16384  87380  1        1       60.01    86526.84
16384  87380  1        1       60.01    84478.01

2.6.27-rc6
Throughput 1037.98 MB/sec 4 procs

16384  87380  1        1       60.00    80293.80
16384  87380  1        1       60.00    80266.60
16384  87380  1        1       60.00    80394.83
16384  87380  1        1       60.01    80397.27

I spent two weeks chasing various and sundry netperf numbers recently,
only learning in the process that netperf is _utterly immune_ to
bisection.  Tbench numbers don't look promising for bisection from here.

Note to quixotic self: destroy log immediately lest you be tempted.

	-Mike

