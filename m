Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZFWOUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZFWOUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756285AbZFWOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:20:47 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:36914 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756043AbZFWOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:20:46 -0400
X-IronPort-AV: E=Sophos;i="4.42,275,1243807200"; 
   d="scan'208";a="28600535"
Message-ID: <4A40E4E2.3090002@inria.fr>
Date: Tue, 23 Jun 2009 16:21:22 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu>
In-Reply-To: <20090623131450.GA31519@elte.hu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> You can also do a profile with such events:
>
>   perf record -f -e r1000ffe0 ./hackbench 10
>
> and look at it via 'perf report'.
>   

I am not sure what the perf.data profile file contains but 'perf report'
only shows percentages. Is there a way to get a 'perf stat'-like output
from 'perf report'? Or maybe just have a -f option in 'perf stat' to
send the output into a file (with the PID in the name).

By the way, there's a typo in the description in
tools/perf/Documentation/perf-report.txt, you want s/via perf report/via
perf record/

> [ Note, there's no need to specify any --follow-* flags as that is
>   implicit in 'perf'. (and you'll probably also notice that perf
>   stat is a lot faster at following fast-forking or
>   context-switching workloads than is pfmon, because it's not ptrace
>   based.) ]
>   

What about threads? I didn't find any way to get per-thread counters.

Ideally, I'd like to be able to see no perf-related output on
stdout/stderr at runtime, and later have a look at per-thread counters
like 'perf stat' does at runtime.

thanks,
Brice

