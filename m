Return-Path: <linux-kernel-owner+w=401wt.eu-S1757929AbYLLMhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbYLLMhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 07:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756407AbYLLMhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 07:37:33 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45269 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbYLLMhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 07:37:33 -0500
Message-ID: <49425B0A.9090808@ext.bull.net>
Date: Fri, 12 Dec 2008 13:37:30 +0100
From: "Gilles.Carry" <Gilles.Carry@ext.bull.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Ma, Chinang" <chinang.ma@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       "Chilukuri, Harita" <harita.chilukuri@intel.com>,
       "Wang, Peter Xihong" <peter.xihong.wang@intel.com>,
       "Nueckel, Hubert" <hubert.nueckel@intel.com>
Subject: Re: CFS scheduler OLTP perforamnce
References: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
In-Reply-To: <BC02C49EEB98354DBA7F5DD76F2A9E80030A74A5FF@azsmsx501.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ma, Chinang a écrit :
> We are evaluating the CFS OLTP performance with 2.6.28-c7 kernel. In this workload once a database foreground process commit a transaction it will signal the log writer process to write to the log file. Foreground processes will wait until log writer finish writing and wake them up. With hundreds of foreground process running in the system, it is important that the log writer get to run as soon as data is available. 
> 
> Here are the experiments we have done with 2.6.28-rc7.
> 1. Increase log writer priority "renice -20 <log writer pid>" while keeping all other processes running in default CFS priority. We get a baseline performance with log latency (scheduling + i/o) at 7 ms.
> 
> 2. To reduce log latency, we set log writer to SCHED_RR with higher priority. We tried "chrt -p 49  <log writer pid>" and got 0.7% boost in performance with log latency reduced to 6.4 ms.
> 
> It seems that in this case renice to higher priority with CFS did not reduce scheduling latency as well as SCHED_RR.

Maybe you should try an RT kernel.

Gilles.
