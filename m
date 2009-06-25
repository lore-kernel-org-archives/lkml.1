Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZFYCBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZFYCBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZFYCBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:01:20 -0400
Received: from smtpauth01.csee.onr.siteprotect.com ([64.26.60.145]:58608 "EHLO
	smtpauth01.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbZFYCBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:01:20 -0400
Date: Wed, 24 Jun 2009 22:12:03 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: performance counter 20% error finding retired instruction count
In-Reply-To: <20090624151010.GA12799@elte.hu>
Message-ID: <Pine.LNX.4.64.0906242200000.12718@pianoman.cluster.toy>
References: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
 <20090624151010.GA12799@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Ingo Molnar wrote:
> * Vince Weaver <vince@deater.net> wrote:
>
> Those ~2100 instructions are executed by your app: as the ELF
> dynamic loader starts up your test-app.
>
> If you have some tool that reports less than that then that tool is
> not being truthful about the true overhead of your application.

I wanted the instruction count of the application, not the loader.
If I wanted the overhead of the loader too, then I would have specified 
it.  I don't think it has anything to do with tools being "less than 
truthful".  I notice perf doesn't seem to include its own overheads into 
the count.

> Also note that applications that only execute 1 million instructions
> are very, very rare - a modern CPU can execute billions of
> instructions, per second, per core.

Yes, I know that.

As I hope you know, the chip designers offer no guarantees with any of the 
performance counters.  So before you can use them, you have to validate 
them a bit to make sure they are returning expected results.  Hence the 
need for microbenchmarks, one of which I used as an example.

You have to be careful with performance counters.  For example, on Pentium 
4, the retired instruction counter will have as much as 2% error on some 
of the spec2k benchmarks because the "fldcw" instruction counts as two 
instructions instead of one.

This kind of difference is important when doing validation work, and can't 
just be swept under the rug with "if you use bigger programs it doesn't 
matter".

It's also nice to be able to skip the loader overhead, as the loader can 
change from system to system and makes it hard to compare counters across 
various machines.  Though it sounds like the perf utility isn't going to 
be supporting this anytime soon.

Vince
