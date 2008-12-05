Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYLEPfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYLEPfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:35:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYLEPf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:35:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47051 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245AbYLEPf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:35:28 -0500
To: Jiaying Zhang <jiayingz@google.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 3/3] kernel tracing prototype
References: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
	<1228278908.4886.49.camel@localhost.localdomain>
	<5df78e1d0812022130g7c5a004bnd729d0a8454f24ed@mail.gmail.com>
	<5df78e1d0812050004q505cba8dnee39997a84d67847@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 05 Dec 2008 10:34:50 -0500
In-Reply-To: <5df78e1d0812050004q505cba8dnee39997a84d67847@mail.gmail.com> (Jiaying Zhang's message of "Fri, 5 Dec 2008 00:04:54 -0800")
Message-ID: <y0my6yuocth.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiaying Zhang <jiayingz@google.com> writes:

> To better answer the question why we want to implement a new kernel
> tracing prototype, here are some performance results we collected before
> with the tbench benchmark. 

Thanks.

> - vanilla 2.6.26 kernel, CONFIG_MARKERS=n
> Throughput 759.352 MB/sec 4
> - markers compiled in, tracing disabled
> Throughput 754.18 MB/sec 4

Is your kernel built with -freorder-blocks?  This option dramatically
reduces the cost of inactive markers/tracepoints.

> - tracing syscall entry/exit, use markers, not logging data to ring_buffer
> Throughput 715.68 MB/sec 4
> - tracing syscall entry/exit, use markers, logging data to ring_buffer
> Throughput 654.056 MB/sec 4

(By the way, how are you doing syscall entry/exit tracing?)


- FChE
