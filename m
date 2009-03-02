Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbZCBJdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbZCBJdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 04:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbZCBJdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 04:33:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756930AbZCBJdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 04:33:32 -0500
Date: Mon, 2 Mar 2009 10:33:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: x86-tip: xine bustage bisection fingers commit
	97286a2b64725aac2d584ddd1f94871f9991d5a1
Message-ID: <20090302093319.GB20897@elte.hu>
References: <1235984665.6195.12.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1235984665.6195.12.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_00,URI_HEX autolearn=no SpamAssassin version=3.2.3
	0.4 URI_HEX                URI: URI hostname has long hexadecimal sequence
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Greetings and Salutations,
> 
> $subject, box is Q6600 X86_64 running v2.6.29-rc6-2261-g0fdaeee
> 
> marge:/root # xine
> This is xine (X11 gui) - a free video player v0.99.6cvs.
> (c) 2000-2007 The xine Team.
> Floating point exception
> 
> [pid  6230] 06:59:50.524473 set_robust_list(0x40e239f0, 0x18 <unfinished ...>
> [pid  6230] 06:59:50.524553 <... set_robust_list resumed> ) = 0 <0.000027>
> [pid  6230] 06:59:50.524648 select(0, NULL, NULL, NULL, {0, 500000} <unfinished ...>
> [pid  6230] 06:59:50.763988 <... select resumed> ) = ? ERESTARTNOHAND (To be restarted) <0.239321>
> [pid  6230] 06:59:50.764012 --- SIGRT_1 (Unknown signal 33) @ 0 (0) ---
> [pid  6230] 06:59:50.764074 setuid(0)   = 0 <0.000014>
> [pid  6230] 06:59:50.764151 futex(0x7fff2745e7a0, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
> [pid  6230] 06:59:50.764213 <... futex resumed> ) = 0 <0.000051>
> [pid  6230] 06:59:50.764255 futex(0x40e23d2c, FUTEX_WAKE_PRIVATE, 1 <unfinished ...>
> [pid  6230] 06:59:50.764298 <... futex resumed> ) = 0 <0.000028>
> [pid  6230] 06:59:50.764346 rt_sigreturn(0x40e23d2c <unfinished ...>
> [pid  6230] 06:59:50.778497 <... rt_sigreturn resumed> ) = 0 <0.014136>
> [pid  6230] 06:59:50.778524 --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> 
> [ 1303.345419] xine[6230] bad frame in rt_sigreturn frame:0000000040e22c28 ip:7f051ca28622 sp:40e23070 orax:ffffffffffffffff in libc-2.8.so[7f051c95c000+14f000]
> ﻿
> 97286a2b64725aac2d584ddd1f94871f9991d5a1 is first bad commit
> commit 97286a2b64725aac2d584ddd1f94871f9991d5a1
> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Date:   Fri Feb 27 10:28:48 2009 -0800
> 
>     x86: signal: intrroduce get_sigframe() and replace get_sigstack()
>     
>     Impact: cleanup

ok, that's the same area Jaswinder Singh Rajput bisected a 
breakage back to. I've excluded these commits from tip:master 
for now and pushed out an updated tip:master tree.

Hiroshi-san, mind having a look at this problem?

	Ingo
