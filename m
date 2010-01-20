Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661Ab0ATPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab0ATPCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575Ab0ATPCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:02:37 -0500
Received: from mail2.picochip.com ([82.111.145.34]:50843 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519Ab0ATPCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:02:36 -0500
Date: Wed, 20 Jan 2010 15:03:03 +0000
From: Jamie Iles <jamie.iles@picochip.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Jamie Iles <jamie.iles@picochip.com>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com,
       =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
	description in sysfs
Message-ID: <20100120150303.GG4089@wear.picochip.com>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus> <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop> <20100120135553.GA22897@n2100.arm.linux.org.uk> <1263996080.4283.1064.camel@laptop> <20100120144140.GB22897@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120144140.GB22897@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Wed, 20 Jan 2010 15:01:45 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 02:41:40PM +0000, Russell King - ARM Linux wrote:
> Given that history has shown that identification schemes on ARM change
> in extremely annoying ways, I don't think decoding these registers to
> some kind of textual representation for /proc/cpuinfo is the right
> approach.  It might instead make more sense to just export the entire
> set of CPU ID registers to userspace, and let userspace grapple with
> the complexities of decoding the information it wants from them.
Yes, this would probably be the best generic solution, but in the specific
case of ARM perfevents, the kernel code already has to decode some of the CPU
ID registers to work out what set of events to use. Why make userspace do all
of this decoding again? The x86 code sets up the x86_pmu depending on CPU type
so this is doing a similar thing (although it is easier for x86).

Having perf do all of this decoding for all of the supported CPU types when
the kernel has already done it once and maintaining 2 sets of event lists
seems a bit fiddly compared to simply exporting the supported events from the
kernel...

Jamie
