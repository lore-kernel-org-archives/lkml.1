Return-Path: <linux-kernel-owner+w=401wt.eu-S1759481AbYLKXZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481AbYLKXZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758783AbYLKXZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:25:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:41169 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758687AbYLKXZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:25:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,207,1228118400"; 
   d="scan'208";a="473273566"
From: "Ma, Chinang" <chinang.ma@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
Date: Thu, 11 Dec 2008 16:25:06 -0700
Subject: CFS scheduler OLTP perforamnce
Thread-Topic: CFS scheduler OLTP perforamnce
Thread-Index: Aclb57OanrTi/daKTMORB++KI0JLSQ==
Message-ID: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are evaluating the CFS OLTP performance with 2.6.28-c7 kernel. In this workload once a database foreground process commit a transaction it will signal the log writer process to write to the log file. Foreground processes will wait until log writer finish writing and wake them up. With hundreds of foreground process running in the system, it is important that the log writer get to run as soon as data is available. 

Here are the experiments we have done with 2.6.28-rc7.
1. Increase log writer priority "renice -20 <log writer pid>" while keeping all other processes running in default CFS priority. We get a baseline performance with log latency (scheduling + i/o) at 7 ms.

2. To reduce log latency, we set log writer to SCHED_RR with higher priority. We tried "chrt -p 49  <log writer pid>" and got 0.7% boost in performance with log latency reduced to 6.4 ms.

It seems that in this case renice to higher priority with CFS did not reduce scheduling latency as well as SCHED_RR.

-Chinang
