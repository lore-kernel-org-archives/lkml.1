Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYAXPpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYAXPpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 10:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYAXPpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 10:45:24 -0500
Received: from mga07.intel.com ([143.182.124.22]:41258 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570AbYAXPpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:45:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,244,1199692800"; 
   d="scan'208";a="370839040"
Message-ID: <4798B19D.2040400@linux.intel.com>
Date: Thu, 24 Jan 2008 07:41:17 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange interaction between latencytop and the scheduler
References: <47962DD1.9050800@gmail.com> <47963E2E.9020501@linux.intel.com> <47964572.2060002@gmail.com> <47985BCA.2050500@gmail.com>
In-Reply-To: <47985BCA.2050500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Török Edwin wrote:
> 
> Latencytop userspace tool shows latencies > 0.1 msec, thus capturing
> backtraces for latencies <0.1msec could be avoided.
> If I apply the patch below, then enabling latencytop doesn't freeze X
> when running the "10-threads doing infloop usleep(1)" test.

ok I like the idea; I would propose though to make the 0.1 msec a sysctl or something,
so that people who really care about latencies lower than that can just set that lower.
(and the tool can then read the value and use that)

> Still, I don't want to loose track of the latencies we didn't collect
> backtraces for, so I added a special "untraced" category, reported as
> first line in /proc/latency_stats. If needed, instead of hardcoding the
> threshold, it could be made a sysctl, or set via writing to
> /proc/latency_stats,...

yeah for the total it makes sense; I'll do the sysctl thing for the threshold
and integrate this idea as well. Thanks a lot!
