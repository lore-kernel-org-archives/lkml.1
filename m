Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZBITxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZBITxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbZBITw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:52:57 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57872 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZBITw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:52:57 -0500
Subject: Re: cgroup, RT reservation per core(s)?
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 20:52:54 +0100
Message-Id: <1234209174.5951.165.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 19:30 +0000, Rolando Martins wrote:
> Hi,
> I would like to have in a quad-core, 2 cores totally (100%) dedicated
> to RT tasks (SCHED_RR and SCHED_FIFO) and the other 2 cores with
> normal behavior, better said,  allowing SCHED_OTHER & SCHED_FIFO &
> SCHED_RR tasks but still with a RT reservation. Follows an example:
> 
> 
> # Setup first domain (cpu 0,1)
> echo 0-1 > /dev/cgroup/0/cpuset.cpus
> echo 0 > /dev/cgroup/0/cpuset.mems
> 
> # Setup RT bandwidth for firstdomain (80% for RT, 20% others)
> echo 1000000 > /dev/cgroup/0/cpu.rt_period_us
> echo 800000 > /dev/cgroup/0/cpu.rt_runtime_us
> 
> 
> # Setup second domain (cpu 2,3)
> mkdir /dev/cgroup/1
> echo 2-3 > /dev/cgroup/1/cpuset.cpus
> echo 0 > /dev/cgroup/1/cpuset.mems
> 
> # Setup RT bandwidth for second domain (100% for RT)
> echo 1000000 > /dev/cgroup/1/cpu.rt_period_us
> echo 1000000 > /dev/cgroup/1/cpu.rt_runtime_us
> 
> Is there anyway for doing this?

Nope, but why do you need bandwidth groups if all you want is a full
cpu?

Just the cpuset should be plenty

