Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZKCEcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZKCEcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbZKCEcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:32:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:64231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZKCEcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:32:20 -0500
X-ExtLoop1: 1
Subject: Re: UDP-U stream performance regression on 32-rc1 kernel
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: alex.shi@intel.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
In-Reply-To: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
References: <1257220036.3819.193.camel@alexs-hp.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Nov 2009 12:33:10 +0800
Message-Id: <1257222791.16282.46.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 11:47 +0800, Alex Shi wrote:
> We found the UDP-U 1k/4k stream of netperf benchmark have some
> performance regression from 10% to 20% on our Tulsa and some NHM
> machines. 
﻿
perf events shows function find_busiest_group consumes about 4.5% cpu time
with the patch while it only consumes 0.5% cpu time without the patch.

The communication between netperf client and netserver is very fast.
When netserver receives a message and there is no new message available,
it goes to sleep and scheduler calls idle_balance => load_balance_newidle.
load_balance_newidle spends too much time and a new message arrives quickly
before load_balance_newidle ends.

As the comments in the patch say hackbench benefits from it, I tested hackbench
on Nehalem and core2 machines. hackbench does benefit from it, about 6% on
nehalem machines, but doesn't benefit on core2 machines.

Yanmin

> Bisecting found it is due to the following commitment.  
> 
> commit 840a0653100dbde599ae8ddf83fa214dfa5fd1aa
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Sep 4 11:32:54 2009 +0200


