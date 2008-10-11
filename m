Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYJKLQC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYJKLQC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 07:16:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYJKLPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 07:15:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbYJKLPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 07:15:52 -0400
Date: Sat, 11 Oct 2008 13:22:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
Message-ID: <20081011112218.GA12131@one.firstfloor.org>
References: <20081009171453.GA15321@redhat.com> <200810111459.53306.nickpiggin@yahoo.com.au> <20081011080812.GA9880@one.firstfloor.org> <200810111929.19891.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810111929.19891.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 07:29:19PM +1100, Nick Piggin wrote:
> I also think there are reasonable arguments the other way, and I
> personally also think it might be better to leave it 128 (even
> if it is unlikely, introducing a regression is not good).

The issue is also that the regression will be likely large.
False sharing can really hurt when it hits as you know, because
the penalties are so large.

> > There are millions and millions of P4s around.
> > And they're not that old, they're still shipping in fact.
> 
> Still shipping in anything aside from 1s systems?

Remember the first Core2 based 4S (Tigerton) Xeon was only introduced last year 
and that market is quite conservative. For 2S it's a bit longer, but
it wouldn't surprise me there if new systems are still shipping.

Also to be honest I doubt the theory that older systems
are never upgraded to newer OS.

> That would be nice. It would be interesting to know what is causing
> the slowdown.

At least that test is extremly cache footprint sensitive. A lot of the
cache misses are surprisingly in hd_struct, because it runs 
with hundred of disks and each needs hd_struct references in the fast path. 
The recent introduction of fine grained per partition statistics
caused a large slowdown. But I don't think kernel workloads
are normally that extremly cache sensitive.

-Andi
-- 
ak@linux.intel.com
