Return-Path: <linux-kernel-owner+w=401wt.eu-S1754300AbZBOTla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbZBOTla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZBOTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:41:22 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbZBOTlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:41:21 -0500
Date: Sun, 15 Feb 2009 20:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, markus.t.metzger@gmail.com
Subject: Re: [PATCH -mm] tracing: Fix section mismatch in
	trace_hw_branches.c
Message-ID: <20090215194116.GA18517@elte.hu>
References: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10902131936p5e0997c6p57f659457a9cc356@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

>   Impact: Fix section mismatch
> 
> The function bts_trace_init() references a variable
> bts_hotcpu_notifier which is marked
> as __cpuinitdata. Thus causes section mismatch. This patch fixes it.
> 
>   LD      kernel/trace/built-in.o
> WARNING: kernel/trace/built-in.o(.text+0xc90c): Section mismatch in
> reference from the function bts_trace_init() to the variable
> .cpuinit.data:bts_hotcpu_notifier
> The function bts_trace_init() references
> the variable __cpuinitdata bts_hotcpu_notifier.
> This is often because bts_trace_init lacks a __cpuinitdata
> annotation or the annotation of bts_hotcpu_notifier is wrong.
> 
> WARNING: kernel/trace/built-in.o(.text+0xc92a): Section mismatch in
> reference from the function bts_trace_reset() to the variable
> .cpuinit.data:bts_hotcpu_notifier
> The function bts_trace_reset() references
> the variable __cpuinitdata bts_hotcpu_notifier.
> This is often because bts_trace_reset lacks a __cpuinitdata
> annotation or the annotation of bts_hotcpu_notifier is wrong.
> 
> Thanks.

Applied to tip:tracing/hw-branch-tracing, thanks Rakib!

	Ingo
