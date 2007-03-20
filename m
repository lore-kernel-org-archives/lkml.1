Return-Path: <linux-kernel-owner+w=401wt.eu-S965874AbXCTSvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965874AbXCTSvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965908AbXCTSvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:51:11 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52387 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965825AbXCTSvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:51:07 -0400
Date: Tue, 20 Mar 2007 11:49:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Miller <davem@davemloft.net>,
       virtualization@lists.linux-foundation.org, jbeulich@novell.com,
       jeremy@goop.org, xen-devel@lists.xensource.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, anthony@codemonkey.ws,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [patch 13/26] Xen-paravirt_ops: Consistently wrap paravirt ops
 callsites to make them patchable
In-Reply-To: <20070320192118.GD4286@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0703201145570.6730@woody.linux-foundation.org>
References: <20070319.120854.30182994.davem@davemloft.net>
 <20070319.204712.118947830.davem@davemloft.net> <m13b40wnrb.fsf@ebiederm.dsl.xmission.com>
 <200703201428.50564.ak@suse.de> <m1ircvswzz.fsf@ebiederm.dsl.xmission.com>
 <20070320174159.GA4286@bingen.suse.de> <Pine.LNX.4.64.0703200947501.6730@woody.linux-foundation.org>
 <20070320180359.GB4286@bingen.suse.de> <Pine.LNX.4.64.0703201022040.6730@woody.linux-foundation.org>
 <20070320192118.GD4286@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Mar 2007, Andi Kleen wrote:
> 
> So what is your proposed alternative to handle long backtraces? 
> You didn't answer that question. Please do, I'm curious about your thoughts
> in this area.

the thing is, I'd rather see a long backtrace that is hard to decipher but 
that *never* *ever* causes any additional problems, over a pretty one.

Because that's really the issue: do you want a "pretty" backtrace, or do 
you want one that is rock solid but has some crud in it.

I'll take the rock solid one any day. Especially as even the pretty one 
won't fix the most common problem, which is "I don't see the caller" (due 
to inlining or tail-calls).

In contrast, the ugly backtrace will have some "garbage entries" from 
previous frames that didn't get overwritten, but there have actually been 
(admittedly rare) cases where those garbage entries have given hints about 
what happened just before.

			Linus
