Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYIFXWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYIFXWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYIFXWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:22:11 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:16117 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYIFXWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:22:10 -0400
Message-ID: <48C31095.6020206@hp.com>
Date: Sat, 06 Sep 2008 19:21:57 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Benchmarking results: DSS elapsed time values w/ rq_affinity=0/1
 - Jens' for-2.6.28 tree
References: <48C15C02.7060504@hp.com>
In-Reply-To: <48C15C02.7060504@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some results obtained during runs where we varied the number of
 readers & the multi-block read counts. 5 runs per rq_affinity setting
were done, and the averages are plotted at:

http://free.linux.hp.com/~adb/jens/08-09-05/by_mbr.jpeg

In all cases we are seeing a noticeable improvement in reduction of
elapsed time to perform the tasks, and again we are seeing much tighter
deviations with rq_affinity set to 1:

                          Min   Avg   Max   Std Dev
                         ----- ----- -----  --------
mbrs= 32 nrdrs= 64 rq=0: 30.57 31.50 34.06  1.456108
mbrs= 32 nrdrs= 64 rq=1: 29.27 29.59 29.96  0.325469   6.05% improvement

mbrs= 32 nrdrs=128 rq=0: 28.14 28.48 29.32  0.480208
mbrs= 32 nrdrs=128 rq=1: 27.54 27.88 28.48  0.359194   2.11% improvement

mbrs= 32 nrdrs=256 rq=0: 33.05 33.70 34.30  0.548151
mbrs= 32 nrdrs=256 rq=1: 33.10 33.36 33.74  0.257158   1.01% improvement

mbrs= 64 nrdrs= 64 rq=0: 30.53 30.74 31.10  0.255441
mbrs= 64 nrdrs= 64 rq=1: 29.40 29.65 29.91  0.187216   3.55% improvement

mbrs= 64 nrdrs=128 rq=0: 28.09 28.79 29.23  0.484149
mbrs= 64 nrdrs=128 rq=1: 27.73 27.96 28.33  0.226429   2.89% improvement

mbrs= 64 nrdrs=256 rq=0: 33.35 34.04 34.76  0.518816
mbrs= 64 nrdrs=256 rq=1: 33.02 33.13 33.25  0.088034   2.67% improvement

mbrs=128 nrdrs= 64 rq=0: 30.37 30.75 31.23  0.329439
mbrs=128 nrdrs= 64 rq=1: 29.20 29.49 29.82  0.221179   4.08% improvement

mbrs=128 nrdrs=128 rq=0: 28.04 28.54 29.00  0.392785
mbrs=128 nrdrs=128 rq=1: 27.76 28.08 28.26  0.190840   1.63% improvement

mbrs=128 nrdrs=256 rq=0: 33.37 33.89 34.30  0.448297
mbrs=128 nrdrs=256 rq=1: 33.04 33.30 33.56  0.203175   1.76% improvement

mbrs=256 nrdrs= 64 rq=0: 30.55 30.80 30.94  0.167392
mbrs=256 nrdrs= 64 rq=1: 29.23 29.57 29.91  0.305156   3.99% improvement

mbrs=256 nrdrs=128 rq=0: 28.38 28.82 29.20  0.305172
mbrs=256 nrdrs=128 rq=1: 27.78 27.92 28.11  0.142583   3.12% improvement

mbrs=256 nrdrs=256 rq=0: 33.25 34.21 34.88  0.598398
mbrs=256 nrdrs=256 rq=1: 33.11 33.23 33.48  0.154499   2.88% improvement

