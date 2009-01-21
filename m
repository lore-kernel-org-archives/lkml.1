Return-Path: <linux-kernel-owner+w=401wt.eu-S1763754AbZAUKRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763754AbZAUKRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757943AbZAUKNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:13:21 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58984 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764238AbZAUKNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:13:17 -0500
Date: Wed, 21 Jan 2009 11:13:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] x86: Merge hardirq.h
Message-ID: <20090121101307.GD18728@elte.hu>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232457345-12366-5-git-send-email-brgerst@gmail.com> <4976DA9C.7000500@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4976DA9C.7000500@kernel.org>
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


* Tejun Heo <tj@kernel.org> wrote:

> Brian Gerst wrote:
> > Remove unused idle_timestamp field from 32-bit.
> 
> Dropped.  X86_32 doesn't build.  X86_64 UP doesn't build.  Please at 
> least do compile testing on all four combinations before sending the 
> patches.

While this patch was indeed broken, generally for -tip patches we are very 
permissive and do not require testing 4 .config variants: compile testing 
on the bit width x86 variant that is being modified is enough. If both 
variant are modified (as in this case) then compiling the 32-bit and 
64-bit defconfig is enough.

If some build failure slips through it will be handled by automated 
testing facilities (such as -tip's testing) - it really does not scale if 
we expect developers to build kernels they dont use (and dont care about 
nearly as much as about their primary config).

This lowers the bar of entry to developers who submit their patches from 
low-powered hardware and simply dont have the means to do wide build 
testing. The many .config variations are not really the developer's fault 
but our collective fault. Developers should spend their time thinking 
about patches, not waiting for the nth kernel build to finish.

	Ingo
