Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbYIJFx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbYIJFx6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 01:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYIJFxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 01:53:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36315 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYIJFxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 01:53:48 -0400
Date: Wed, 10 Sep 2008 07:53:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: heukelum@fastmail.fm, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [RFC/PATCH] i386: handle all exceptions with interrupts off
	initially
Message-ID: <20080910055337.GA9765@elte.hu>
References: <1220990178-29773-1-git-send-email-heukelum@fastmail.fm> <48C73EB8.8020405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C73EB8.8020405@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> heukelum@fastmail.fm wrote:
>> From: Alexander van Heukelum <heukelum@fastmail.fm>
>>
>> x86_64 handles all exceptions with interrupts off initially, this
>> bisectable patch set does the same for i386, in (very) small steps.
>> If this is acceptable, it would make further unification of traps_32.c
>> and traps_64.c a lot easier. If it is not... why?
>>
>
> The only reason not to is that one generally doesn't want to disable 
> interrupts unless necessary (bad for latency.) On 64 bits there are 
> stack switches which make disabling interrupts mandatory.  The only 
> pitfall is if there is any code which is likely to take time, but I 
> highly doubt it.

the entry paths here are really short (we enable irqs almost 
immediately) so it's a non-issue in terms of worst-case latencies.

> In other words, it's not something we want to do "just because", but 
> to the extent that it provides real benefit, it makes sense.

this is historically pretty fragile code so bringing the 32-bit and 
64-bit variants more in line sounds like a good reason to me. For 
example we had various long-living irq state annotation bugs (the 
combination of kprobes and lockdep, etc.) that remained unfixed partly 
due to this assymetry.

There will be details i'm sure, but the series looks quite bisectable.

	Ingo
