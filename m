Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbZKCDp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbZKCDp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 22:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757862AbZKCDpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 22:45:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:28639 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757843AbZKCDpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 22:45:55 -0500
X-ExtLoop1: 1
Subject: UDP-U stream performance regression on 32-rc1 kernel
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, "Zhang, Yanmin" <yanmin.zhang@intel.com>
Content-Type: text/plain
Organization: intel.com
Date: Tue, 03 Nov 2009 11:47:16 +0800
Message-Id: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found the UDP-U 1k/4k stream of netperf benchmark have some
performance regression from 10% to 20% on our Tulsa and some NHM
machines. Bisecting found it is due to the following commitment.  

commit 840a0653100dbde599ae8ddf83fa214dfa5fd1aa
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Sep 4 11:32:54 2009 +0200

    sched: Turn on SD_BALANCE_NEWIDLE
    
    Start the re-tuning of the balancer by turning on newidle.
    
    It improves hackbench performance and parallelism on a 4x4 box.
    The "perf stat --repeat 10" measurements give us:
    
      domain0             domain1
      .......................................
     -SD_BALANCE_NEWIDLE -SD_BALANCE_NEWIDLE:
       2041.273208  task-clock-msecs         #      9.354 CPUs    ( +-   0.363% )
    
     +SD_BALANCE_NEWIDLE -SD_BALANCE_NEWIDLE:
       2086.326925  task-clock-msecs         #     11.934 CPUs    ( +-   0.301% )
    
     +SD_BALANCE_NEWIDLE +SD_BALANCE_NEWIDLE:
       2115.289791  task-clock-msecs         #     12.158 CPUs    ( +-   0.263% )

BRGs    
Alex 

