Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbZBAIcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbZBAIcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 03:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbZBAIcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 03:32:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:59210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbZBAIcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 03:32:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,359,1231142400"; 
   d="scan'208";a="427144009"
Subject: Re: hackbench [pthread mode] regression with 2.6.29-rc3
From: Lin Ming <ming.m.lin@intel.com>
To: peterz@infradead.org
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
References: <1233473426.2604.13.camel@ymzhang>
	 <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 01 Feb 2009 16:29:21 +0800
Message-Id: <1233476961.13659.12.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Bisect located below patch.
> commit 490dea45d00f01847ebebd007685d564aaf2cd98
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Mon Nov 24 17:06:57 2008 +0100
> 
>    itimers: remove the per-cpu-ish-ness
> 
>    Either we bounce once cacheline per cpu per tick, yielding n^2 bounces
>    or we just bounce a single..
> 
>    Also, using per-cpu allocations for the thread-groups complicates the
>    per-cpu allocator in that its currently aimed to be a fixed sized
>    allocator and the only possible extention to that would be vmap based,
>    which is seriously constrained on 32 bit archs.
> 
> 
> After above patch is reverted, hackbench result is restored.

oltp has ~3% regression with 2.6.29-rc3 on 4core*2p stokley machine.
After above patch reverted, the regression disappeared.

Lin Ming

