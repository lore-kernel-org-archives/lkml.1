Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYFBWNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYFBWNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYFBWMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:12:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYFBWMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:12:54 -0400
Message-ID: <48447052.3030300@redhat.com>
Date: Mon, 02 Jun 2008 18:12:34 -0400
From: Hideo AOKI <haoki@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, peterz@infradead.org
CC: Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Hideo AOKI <haoki@redhat.com>
Subject: Kernel marker has no performance impact on ia64.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I evaluated overhead of kernel marker using linux-2.6-sched-fixes
git tree, which includes several markers for LTTng, using an ia64
server.

While the immediate trace mark feature isn't implemented on ia64,
there is no major performance regression. So, I think that we 
don't have any issues to propose merging marker point patches 
into Linus's tree from the viewpoint of performance impact.

I prepared two kernels to evaluate. The first one was compiled
without CONFIG_MARKERS. The second one was enabled CONFIG_MARKERS.

I downloaded the original hackbench from the following URL:
http://devresources.linux-foundation.org/craiger/hackbench/src/hackbench.c

I ran hackbench 5 times in each condition and calculated the
average and difference between the kernels.  

    The parameter of hackbench: every 50 from 50 to 800
    The number of CPUs of the server: 2, 4, and 8

Below is the results. As you can see, major performance
regression wasn't found in any case. Even if number of processes
increases, differences between marker-enabled kernel and marker-
disabled kernel doesn't increase. Moreover, if number of CPUs 
increases, the differences doesn't increase either.

Curiously, marker-enabled kernel is better than marker-disabled
kernel in more than half cases, although I guess it comes from
the difference of memory access pattern.


* 2 CPUs 

Number of | without      | with         | diff     | diff    |
processes | Marker [Sec] | Marker [Sec] |   [Sec]  |   [%]   |
--------------------------------------------------------------
       50 |      4.811   |       4.872  |  +0.061  |  +1.27  |
      100 |      9.854   |      10.309  |  +0.454  |  +4.61  |
      150 |     15.602   |      15.040  |  -0.562  |  -3.6   |
      200 |     20.489   |      20.380  |  -0.109  |  -0.53  |
      250 |     25.798   |      25.652  |  -0.146  |  -0.56  |
      300 |     31.260   |      30.797  |  -0.463  |  -1.48  |
      350 |     36.121   |      35.770  |  -0.351  |  -0.97  |
      400 |     42.288   |      42.102  |  -0.186  |  -0.44  |
      450 |     47.778   |      47.253  |  -0.526  |  -1.1   |
      500 |     51.953   |      52.278  |  +0.325  |  +0.63  |
      550 |     58.401   |      57.700  |  -0.701  |  -1.2   | 
      600 |     63.334   |      63.222  |  -0.112  |  -0.18  |
      650 |     68.816   |      68.511  |  -0.306  |  -0.44  |
      700 |     74.667   |      74.088  |  -0.579  |  -0.78  |
      750 |     78.612   |      79.582  |  +0.970  |  +1.23  |
      800 |     85.431   |      85.263  |  -0.168  |  -0.2   |
--------------------------------------------------------------

* 4 CPUs 

Number of | without      | with         | diff     | diff    |
processes | Marker [Sec] | Marker [Sec] |   [Sec]  |   [%]   |
--------------------------------------------------------------
       50 |      2.586   |       2.584  |  -0.003  |  -0.1   |
      100 |      5.254   |       5.283  |  +0.030  |  +0.56  |
      150 |      8.012   |       8.074  |  +0.061  |  +0.76  |
      200 |     11.172   |      11.000  |  -0.172  |  -1.54  |
      250 |     13.917   |      14.036  |  +0.119  |  +0.86  |
      300 |     16.905   |      16.543  |  -0.362  |  -2.14  |
      350 |     19.901   |      20.036  |  +0.135  |  +0.68  |
      400 |     22.908   |      23.094  |  +0.186  |  +0.81  |
      450 |     26.273   |      26.101  |  -0.172  |  -0.66  |
      500 |     29.554   |      29.092  |  -0.461  |  -1.56  |
      550 |     32.377   |      32.274  |  -0.103  |  -0.32  |
      600 |     35.855   |      35.322  |  -0.533  |  -1.49  |
      650 |     39.192   |      38.388  |  -0.804  |  -2.05  |
      700 |     41.744   |      41.719  |  -0.025  |  -0.06  |
      750 |     45.016   |      44.496  |  -0.520  |  -1.16  |
      800 |     48.212   |      47.603  |  -0.609  |  -1.26  |
--------------------------------------------------------------

* 8 CPUs 

Number of | without      | with         | diff     | diff    |
processes | Marker [Sec] | Marker [Sec] |   [Sec]  |   [%]   |
--------------------------------------------------------------
       50 |      2.094   |       2.072  |  -0.022  |  -1.07  |
      100 |      4.162   |       4.273  |  +0.111  |  +2.66  |
      150 |      6.485   |       6.540  |  +0.055  |  +0.84  |
      200 |      8.556   |       8.478  |  -0.078  |  -0.91  |
      250 |     10.458   |      10.258  |  -0.200  |  -1.91  |
      300 |     12.425   |      12.750  |  +0.325  |  +2.62  |
      350 |     14.807   |      14.839  |  +0.032  |  +0.22  |
      400 |     16.801   |      16.959  |  +0.158  |  +0.94  |
      450 |     19.478   |      19.009  |  -0.470  |  -2.41  |
      500 |     21.296   |      21.504  |  +0.208  |  +0.98  |
      550 |     23.842   |      23.979  |  +0.137  |  +0.57  |
      600 |     26.309   |      26.111  |  -0.198  |  -0.75  |
      650 |     28.705   |      28.446  |  -0.259  |  -0.9   |
      700 |     31.233   |      31.394  |  +0.161  |  +0.52  |
      750 |     34.064   |      33.720  |  -0.344  |  -1.01  |
      800 |     36.320   |      36.114  |  -0.206  |  -0.57  |
--------------------------------------------------------------

Best regards,
Hideo


P.S. When I compiled the linux-2.6-sched-fixes tree on ia64, I
had to revert the following git commit since pteval_t is defined
on x86 only.

commit 8686f2b37e7394b51dd6593678cbfd85ecd28c65
Date:   Tue May 6 15:42:40 2008 -0700

    generic, x86, PAT: fix mprotect

-- 
Hitachi Computer Products (America) Inc.
