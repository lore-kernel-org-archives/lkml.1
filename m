Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYGRHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYGRHLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYGRHLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 03:11:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49555 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYGRHLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 03:11:35 -0400
Date: Fri, 18 Jul 2008 09:11:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Mindalev <lists@r000n.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [Bug #11035] System hangs on 2.6.26-rc8
Message-ID: <20080718071121.GB6875@elte.hu>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.xt.SzLcIB@albercik> <4878D259.7050403@r000n.net> <487CA8E5.8020208@r000n.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487CA8E5.8020208@r000n.net>
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


* Roman Mindalev <lists@r000n.net> wrote:

> I done bisection.
> Result below:
> 
> 8f46924600e30b140445f5b84abe9b80d2fff5fb is first bad commit
> commit 8f46924600e30b140445f5b84abe9b80d2fff5fb
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Jan 30 13:34:09 2008 +0100
> 
>     x86: enable CONFIG_DEBUG_PAGEALLOC more widely
> 
>     make CONFIG_DEBUG_PAGEALLOC universally available.
> 
>     CONFIG_HIBERNATION and CONFIG_HUGETLBFS was disabling it, for no
>     particular reason.

as far as i can see you see a lockup under certain circumstances, right?

this debug option catches use-after-free and other types of invalid 
memory accesses. When it catches a bug the kernel most likely crashes 
and produces a backlog. Because you are in graphical mode that is not 
visible.

This would possibly be debuggable if you set up netconsole logging to 
another system on a local LAN - see 
Documentation/networking/netconsole.txt.

Vegard - would it be possible to make DEBUG_PAGEALLOC faults single-shot 
and non-fatal, just like kmemcheck does it? That way people would see a 
nice kernel message instead of an immediate crash. That means we'd have 
to find a reliable filter for DEBUG_PAGEALLOC-provoked pagefaults though 
...

	Ingo
