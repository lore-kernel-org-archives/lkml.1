Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYDJKOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYDJKOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 06:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYDJKOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 06:14:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40534 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbYDJKOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:14:24 -0400
Date: Thu, 10 Apr 2008 12:14:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: astarikovskiy@suse.de, len.brown@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mpparse merge
Message-ID: <20080410101408.GA12853@elte.hu>
References: <20080410092947.GA32376@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080410092947.GA32376@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


(Cc:-ing lkml because obviously others are interested in this topic too)

* Andi Kleen <andi@firstfloor.org> wrote:

> Refering to 
> 
> commit 9d92083afb7cabe86c166dce9cc569eabbbd6f99
> Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> Date:   Fri Apr 4 23:43:18 2008 +0400
> 
>     x86: merge mpparse_{32,64}.c
> 
> in linux-next.
> 
> About half of the ifdefs seem to be because 32bit does irq compression 
> and 64bit does not. Len removed that at some point, but when the files 
> are merged I would rather just readd 64bit irq compression (or move 
> 64bit over to per cpu vectors) than have this ifdef jungle

the way Alexey did it is the safest way of doing unifications: keep it 
simple and finegrained first, keep the more complex steps to later. We 
try to stick to that even if there's a temporary jungle of #ifdefs. In a 
related discussion (which was unfortunately private too so no URLs) you 
suggested to Alexey to redesign the mp-parsing code first, then unify 
it. That's the worst possible approach to unification and i advise 
everyone against doing it that way. I very much agree with unifying irq 
vector management - it's not a simple task at all.

	Ingo
