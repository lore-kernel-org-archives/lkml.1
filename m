Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYDVItL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYDVItL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756470AbYDVIs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:48:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52860 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbYDVIs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:48:56 -0400
Subject: Re: [PATCH 0/11] Generic smp_call_function() and friends
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
In-Reply-To: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 10:48:53 +0200
Message-Id: <1208854133.7115.214.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 09:57 +0200, Jens Axboe wrote:
> Hi,
> 
> While working on the more scalable and faster
> smp_call_function_single(), the amount of arch duplicated code in there
> botherered me. So I started adding a generic kernel/smp.c helper that
> the archs could use instead.
> 
> Arch code exports two helper functions:
> 
> arch_send_call_function_single_ipi(cpu)
> 	Send call function single ipi to given cpu
> arch_send_call_function_ipi(cpumask)
> 	Send call function ipi to cpus in cpumask
> 
> and then use the generic ipi interrupt helpers to execute the code. I
> converted most of the archs capable of SMP, I think only sparc and
> sparc64 are still missing. Archs set CONFIG_GENERIC_SMP_HELPERS if they
> wish to use the generic helpers for this.
> 
> The end result is that we have unified code for handling ipi for
> function calls. Even with adding special handling for the single cpu
> function call, the diffstat is pretty nice (see below.

Real nice work Jens!

