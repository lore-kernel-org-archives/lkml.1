Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYIEQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYIEQT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 12:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYIEQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 12:19:18 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:4833 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYIEQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 12:19:17 -0400
Message-ID: <48C15C02.7060504@hp.com>
Date: Fri, 05 Sep 2008 12:19:14 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: Benchmarking results: DSS elapsed time values w/ rq_affinity=0/1
 - Jens' for-2.6.28 tree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some DSS results from a 32-way ia64 machine set up to try and analyze
Oracle OLTP & DSS loads (128GB RAM, >200 disks). The data collected was
the elapsed time for DSS runs w/ 128 MBRs and 128 Readers, running on a
kernel generated from Jens Axboe's origin/for-2.6.28 tree. I alternated
runs, setting rq_affinity to 0 and 1 for all disks at the beginning of
each run.

There are a total of 68 data points for each alternative, and the
overall results show a decided improvement for this type of load with
rq_affinity set to 1:

rq=0: min=27.440000 avg=27.980500 max=28.500000 sdev=0.296827
rq=1: min=26.900000 avg=27.071500 max=27.480000 sdev=0.125169

Not only do we see about a 3.25% improvement in reduced average time, we
also see that the run-to-run deviations are much smaller as well. For a
pictorial representation, check out the graph @

http://free.linux.hp.com/~adb/jens/08-09-05/dss.png

The red and green areas illustrate the delta from the average for all
the data points with that rq_affinity setting. (Red being rq_affinity=0,
green being rq_affinity=1.)

I collected some vmstat & iostat data, and will be evaluating that as
well, and perhaps looking into lockstat & profiling data (time permitting).

The system has been set up as part of a collaboration between HP & Red
Hat's Linux performance teams, and we've been using it to analyze
performance characteristics of Oracle loads on large-ish systems, as
well as for evaluating potential code changes.

Alan D. Brunelle
HP Linux Kernel Technology Team
