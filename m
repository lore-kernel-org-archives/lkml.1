Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbYHOMB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbYHOMB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYHOMBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:01:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:60399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753137AbYHOMBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:01:15 -0400
Date: Fri, 15 Aug 2008 07:01:13 -0500
From: Robin Holt <holt@sgi.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ia64 allmodconfig on current mainline
Message-ID: <20080815120113.GN6824@sgi.com>
References: <20080812150608.231a948a.akpm@linux-foundation.org> <200808130022.50501.rjw@sisk.pl> <20080812155806.4e8554a9.akpm@linux-foundation.org> <57C9024A16AD2D4C97DC78E552063EA30844B247@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA30844B247@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 05:21:09PM -0700, Luck, Tony wrote:
> > /opt/crosstool/gcc-3.4.5-glibc-2.3.6/ia64-unknown-linux-gnu/bin/ia64-unknown-linux-gnu-ld: section .data [0000000004ea0000 -> 0000000004f656e7] overlaps section .data.percpu [0000000004e90000 -> 0000000004ea0d17]
> 
> This means there is too much DEFINE_PER_CPU() going on.  Current
> ia64 limit for the sum of all per cpu objects is 64K.  For a
> build using defconfig we seem to be close (56K/64K ... look for
> the address of __per_cpu_end and see how close it is to the top
> of the address space: 0xffffffffffffffff).

Not sure if anybody is looking into this.  Just tried a compile of generic
and allmod.  The differences are not that significant with the exception
of per_cpu__kmem_cache_cpu at 0x28a0.  A couple other low-hanging fruit
here are per_cpu__shadow_flush_counts and per_cpu__mmu_gathers each of
which takes approx 16k.

Thanks,
Robin
