Return-Path: <linux-kernel-owner+w=401wt.eu-S1765373AbXFEQll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765373AbXFEQll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 12:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXFEQle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 12:41:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbXFEQld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 12:41:33 -0400
From: Andi Kleen <ak@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
Date: Tue, 5 Jun 2007 18:37:22 +0200
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
References: <20070522223828.GV11115@waste.org> <20070605090714.22bfcfd4.akpm@linux-foundation.org> <46658C41.9090105@zytor.com>
In-Reply-To: <46658C41.9090105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706051837.22847.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 June 2007 18:16, H. Peter Anvin wrote:

> Yes.  Since there is now a mechanism to get a clean message out, it
> seemed like a good idea to extend the benefit of static determination.
> Andi already had in his tree -- and I copied it -- code to deal with
> stuff like "cpu_has_tsc" as a compile-time constant, eliminating the
> "else" clause.
>
> Depending on the configuration it affects FPU, TSC, 3Dnow.

I don't think it's a good idea for the TSC. There are various
setups where it is unreliable and also often simulators don't 
implement it correctly. And it's always a valuable workaround
to be able to turn it off.

Except possibly for the FPU only features used by the gcc output
should be tested this way. For everything else it is better to 
test at runtime.

That is x86-64 makes some more assumptions. But even it
doesn't assume TSC. 

I added the mechanism to statically evaluate mostly to share cpufeatures.h
between 32bit and 64bit at some point -- but didn't quite finish that work 
before the last merge.

-Andi
