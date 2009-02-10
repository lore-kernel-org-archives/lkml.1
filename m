Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZBJTxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZBJTxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:53:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZBJTxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:53:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59290 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZBJTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:53:36 -0500
Subject: Re: cgroup, RT reservation per core(s)?
From: Peter Zijlstra <peterz@infradead.org>
To: Rolando Martins <rolando.martins@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b6a2d2e20902100932i475c1ee8va99de6e433a6d89a@mail.gmail.com>
References: <b6a2d2e20902091130ha452a97rcfaa2972bfdbe710@mail.gmail.com>
	 <1234209174.5951.165.camel@laptop>
	 <b6a2d2e20902091204p2391799p160ce13971e9f779@mail.gmail.com>
	 <1234271177.23438.24.camel@twins>
	 <b6a2d2e20902100646q6c7073cse86b8f5790a120ac@mail.gmail.com>
	 <1234281602.23438.96.camel@twins>
	 <b6a2d2e20902100932i475c1ee8va99de6e433a6d89a@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Feb 2009 20:53:33 +0100
Message-Id: <1234295613.4699.1.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 17:32 +0000, Rolando Martins wrote:
> 
> For helping others:
> 
> mkdir /dev/cpuset
> mount -t cgroup -o cpuset none /dev/cpuset
> cd /dev/cpuset
> echo 0 > cpuset.sched_load_balance

I'm not quite sure that its allowed to disable load-balance before
creating children. Other than that it looks ok.

> mkdir A
> echo 0-1 > A/cpuset.cpus
> echo 0 > A/cpuset.mems
> mkdir B
> echo 2-3 > B/cpuset.cpus
> echo 0 > B/cpuset.mems
> 
> 
> mount -t cgroup -o cpu none /dev/sched_domain
> cd /dev/sched_domain
> mkdir 1
> echo cpu.rt_runtime_ns > 1/cpu.rt_runtime_ns
> mkdir 1/2
> echo 33333 > 1/2/cpu.rt_runtime_ns
> mkdir 1/3
> echo 33333 > 1/3/cpu.rt_runtime_ns
> mkdir 1/4
> echo 33333 > 1/3/cpu.rt_runtime_ns
> 
> For example, setting the current shell to a specific cpuset(A) and
> sched(1/2):
> 
> echo $$ > /dev/cpuset/A/tasks
> echo $$ > /dev/sched_domain/1/2/tasks
> "execute program"




