Return-Path: <linux-kernel-owner+w=401wt.eu-S932719AbXGTAoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbXGTAoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759894AbXGTAoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:44:14 -0400
Received: from holomorphy.com ([66.93.40.71]:53544 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758940AbXGTAoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:44:13 -0400
Date: Thu, 19 Jul 2007 17:45:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <ak@suse.de>, lkml@rtr.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for review] [7/48] i386: divorce CONFIG_X86_PAE from CONFIG_HIGHMEM64G
Message-ID: <20070720004559.GO11781@holomorphy.com>
References: <20070719348.540885000@suse.de> <20070719134836.0C54214E6E@wotan.suse.de> <20070719145229.GA19858@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719145229.GA19858@infradead.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>
>> PAE is useful for more than supporting more than 4GB RAM.  It supports
>> expanded swapspace and NX executable protections.  Some users may want NX
>> or expanded swapspace support without the overhead or instability of
>> highmem.  For these reasons, the following patch divorces CONFIG_X86_PAE
>> from CONFIG_HIGHMEM64G.

On Thu, Jul 19, 2007 at 03:52:29PM +0100, Christoph Hellwig wrote:
> What overhead of instability of highmem?  Sorry folks but this is utter
> bollocks.  Back in the Caldera days we did a lot of measurement on highmem
> overhead, and CONFIG_HIGHMEM has no measurable overhead at all on a system
> that doesn't use it.  CONFIG_HIGHMEM64G on the other hand has
> a quite visible overhead on small systems, but that's entirely due to the
> bigger page table entries that you need for NX.

The missing context here is CONFIG_VMSPLIT on laptops.

Laptop users, who frequently use CONFIG_VMSPLIT options to avoid
highmem, wanted to turn on NX. Prior to the patch, those options were
barred for all highmem configurations. In response to those requests,
I produced the patch.

The overhead and instability derived from tiny zones as opposed to
kmap()/kunmap(), or at least such was the case historically.


-- wli
