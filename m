Return-Path: <linux-kernel-owner+w=401wt.eu-S934741AbXK3CXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741AbXK3CXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbXK3CXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:23:33 -0500
Received: from ozlabs.org ([203.10.76.45]:43164 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758224AbXK3CXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:23:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch specific percpu setup
Date: Fri, 30 Nov 2007 13:23:30 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
References: <20071127001407.859743255@sgi.com> <200711291017.52727.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281528130.17481@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281528130.17481@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301323.30757.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 November 2007 10:36:06 Christoph Lameter wrote:
> The code becomes much simpler if gs would point to the beginning of the
> per cpu area and if the __per_cpu_offset[i] would do the same. No weird
> __per_cpu_start offsetting anymore.

It is a little weird, but it gave flexibility for most archs.

ISTR I had issues relocating the percpu area to 0, but I look forward to your 
code!

> The generic write/readpercpu functionality introduced by the cpu_alloc
> patchset works best with offsets relative to an arch dependent
> register. All per cpu data (pda, percpu and allocpercpu) is handles as an
> offset relative to the start of the per cpu data.

Hmm, did someone cc me on the patchset and I missed it?

> If the current offset by __per_cpu_start is kept then a per cpu allocator
> may have to dish out addresses that go beyond __per_cpu_end.

Of course; you just need congruence in your allocation across CPUs.  It's 
possible, but no worse than the requirements on other schemes where you can 
reach a variable with a single addition for the CPU.

> I think dealing with a per cpu variable as if it would be an offset
> relative to a base is natural for the typical addressing of cpus based on
> an offset relative to some register.

We've had practical problems getting the compiler to eke out the potential 
benefit.  That's why we settled for an offset between where the compiler 
expected and where the variable actually was.

Cheers,
Rusty.
