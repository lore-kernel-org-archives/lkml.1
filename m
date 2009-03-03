Return-Path: <linux-kernel-owner+w=401wt.eu-S1757668AbZCCHwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbZCCHwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 02:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbZCCHvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 02:51:53 -0500
Received: from viefep18-int.chello.at ([62.179.121.38]:44270 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbZCCHvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 02:51:53 -0500
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH] remove rq->lock from cpuacct cgroup (Was Re:
 [PATCH] cpuacct: add a branch prediction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Bharata B Rao <bharata.rao@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A65455.4030204@cn.fujitsu.com>
	 <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	 <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
	 <1235645076.4645.4781.camel@laptop>
	 <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
	 <1235647682.4948.15.camel@laptop>
	 <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
	 <20090226164509.GB6634@linux.vnet.ibm.com>
	 <20090227095856.ef8c1c05.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090227012915.GF6634@linux.vnet.ibm.com>
	 <20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
	 <1236005770.5330.583.camel@laptop>
	 <20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 08:51:29 +0100
Message-Id: <1236066689.18955.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 08:42 +0900, KAMEZAWA Hiroyuki wrote:

> > Furthermore, if you want something like schedule_work_on() for each cpu,
> > there's schedule_on_each_cpu().
> > 
> It can't pass arguments...Maybe I should use rq->lock here to reset
> other cpu's value.

Why bother with serializing the reset code at all?

But there's always smp_call_function() I suppose.

