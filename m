Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYAPQUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYAPQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:20:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYAPQUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:20:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36222 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbYAPQUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:20:06 -0500
Date: Wed, 16 Jan 2008 17:19:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Colin Fowler <elethiomel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Performance loss 2.6.22->22.6.23->2.6.24-rc7 on CPU intensive
	benchmark on 8 Core Xeon
Message-ID: <20080116161951.GA15000@elte.hu>
References: <cf3edd8d0801140937w755c3e75me83c214ebc1f4cd3@mail.gmail.com> <20080114185520.GA26540@elte.hu> <cf3edd8d0801141442nedf4ac1p6b1fd6bc94900063@mail.gmail.com> <cf3edd8d0801150901p653edeear62d5bc91d9f46981@mail.gmail.com> <20080115220641.GC2665@elte.hu> <cf3edd8d0801151505r54bfd9d0r89f57e3835f295e1@mail.gmail.com> <20080116153505.GB18553@elte.hu> <cf3edd8d0801160810w4302afa5vd731cc6852c778ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf3edd8d0801160810w4302afa5vd731cc6852c778ba@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Colin Fowler <elethiomel@gmail.com> wrote:

> Hi Ingo, I'll need to convince my supervisor first if I can release a 
> binary. Technically anythin glike this needs to go through our 
> University's "innovations department" and requires lengthy paperwork 
> and NDAs :(.

a binary wouldnt work for me anyway. But you could try to write a 
"workload simulator": just pick out the pthread ops and replace the 
worker functions with some dummy stuff that just touches an array that 
has similar size to the tiles (in a tight loop). Make sure it has 
similar context-switch rate and idle percentage as your real workload - 
then send us the .c file. As long as it's a single .c file that runs for 
a few seconds and outputs a precise enough "run time" result, kernel 
developers would pick it up and use it for optimizations. To get the # 
of cpus automatically you can do:

        cpus = system("exit `grep processor /proc/cpuinfo  | wc -l`");
        cpus = WEXITSTATUS(cpus);

and start as many threads as many CPUs there are in the system.

	Ingo
