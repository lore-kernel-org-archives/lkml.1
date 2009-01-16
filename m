Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbZAPHy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbZAPHy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757023AbZAPHx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:53:59 -0500
Received: from mga10.intel.com ([192.55.52.92]:21492 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757140AbZAPHx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:53:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,276,1231142400"; 
   d="scan'208";a="422890133"
Subject: Re: Mainline kernel OLTP performance update
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       sfr@canb.auug.org.au, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
In-Reply-To: <20090116065546.GJ31013@parisc-linux.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>
	 <200901161503.13730.nickpiggin@yahoo.com.au>
	 <20090115201210.ca1a9542.akpm@linux-foundation.org>
	 <200901161746.25205.nickpiggin@yahoo.com.au>
	 <20090116065546.GJ31013@parisc-linux.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 15:53:50 +0800
Message-Id: <1232092430.11429.52.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 23:55 -0700, Matthew Wilcox wrote:
> On Fri, Jan 16, 2009 at 05:46:23PM +1100, Nick Piggin wrote:
> > Intel's OLTP shows SLQB is "neutral" to SLAB. That is, literally within
> > their measurement confidence interval. If it comes down to it, I think we
> > could get them to do more runs to narrow that down, but we're talking a
> > couple of tenths of a percent already.
> 
> I think I can speak with some measure of confidence for at least the
> OLTP-testing part of my company when I say that I have no objection to
> Nick's planned merge scheme.
> 
> I believe the kernel benchmark group have also done some testing with
> SLQB and have generally positive things to say about it (Yanmin added to
> the gargantuan cc).
We did run lots of benchmarks with SLQB. Comparing with SLUB, one highlighting of
SLQB is with netperf UDP-U-4k. On my x86-64 machines, if I start 1 client and 1 server
process and bind them to different physical cpus, the result of SLQB is about 20% better
than SLUB's. If I start CPU_NUM clients and the same number of servers without binding,
the results of SLQB is about 100% better than SLUB's. I think that's because SLQB
doesn't pass through big object allocation to page allocator.
netperf UDP-U-1k has less improvement with SLQB.

The results of other benchmarks have variations. They are good on some machines,
but bad on other machines. However, the variation is small. For example, hackbench's result
with SLQB is about 1 second than with SLUB on 8-core stoakley. After we worked with
Nick to do small code changing, SLQB's result is a little better than SLUB's
with hackbench on stoakley.

We consider other variations as fluctuation.

All the testing use default SLUB and SLQB configuration.

> 
> Did slabtop get fixed to work with SLQB?
> 

