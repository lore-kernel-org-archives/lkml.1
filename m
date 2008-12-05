Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYLESgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYLESgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYLESgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:36:40 -0500
Received: from smtp-out.google.com ([216.239.45.13]:11032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbYLESgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:36:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=gRn/3aQtO+9qCiW1sa/uy4f5wQIebqRVCm/X8KO+5ePMYt5yBiI5Cjkfe78z+sPch
	1b11l3ZxSnet4W7yuSCBg==
MIME-Version: 1.0
In-Reply-To: <y0my6yuocth.fsf@ton.toronto.redhat.com>
References: <5df78e1d0812021626y68c7241ahfdba4d37c7840e10@mail.gmail.com>
	 <1228278908.4886.49.camel@localhost.localdomain>
	 <5df78e1d0812022130g7c5a004bnd729d0a8454f24ed@mail.gmail.com>
	 <5df78e1d0812050004q505cba8dnee39997a84d67847@mail.gmail.com>
	 <y0my6yuocth.fsf@ton.toronto.redhat.com>
Date: Fri, 5 Dec 2008 10:36:34 -0800
Message-ID: <5df78e1d0812051036v6a619c2end01138b60217a74e@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] kernel tracing prototype
From: Jiaying Zhang <jiayingz@google.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 7:34 AM, Frank Ch. Eigler <fche@redhat.com> wrote:
> Jiaying Zhang <jiayingz@google.com> writes:
>
>> To better answer the question why we want to implement a new kernel
>> tracing prototype, here are some performance results we collected before
>> with the tbench benchmark.
>
> Thanks.
>
>> - vanilla 2.6.26 kernel, CONFIG_MARKERS=n
>> Throughput 759.352 MB/sec 4
>> - markers compiled in, tracing disabled
>> Throughput 754.18 MB/sec 4
>
> Is your kernel built with -freorder-blocks?  This option dramatically
> reduces the cost of inactive markers/tracepoints.
No. I will try this this flag and let you know if I see any
performance difference.
Thanks for your suggestion!

>
>> - tracing syscall entry/exit, use markers, not logging data to ring_buffer
>> Throughput 715.68 MB/sec 4
>> - tracing syscall entry/exit, use markers, logging data to ring_buffer
>> Throughput 654.056 MB/sec 4
>
> (By the way, how are you doing syscall entry/exit tracing?)
The way we trace syscall entry/exit is similar to the approach
used in LTTng. When tracing is enabled, a special flag,
TIF_KERNEL_TRACE is set so syscall entry and exit call special
syscall_trace_enter and syscall_trace_exit that are patched
to call trace_mark in our old prototype.

Jiaying

>
>
> - FChE
>
