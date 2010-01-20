Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557Ab0ATPoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0ATPoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836Ab0ATPn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:43:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55895 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0ATPn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:43:56 -0500
Date: Wed, 20 Jan 2010 15:42:50 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jamie Iles <jamie.iles@picochip.com>
Cc: Peter Zijlstra <peterz@infradead.org>, jpihet@mvista.com,
       p.osciak@samsung.com, will.deacon@arm.com,
       =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com, mingo@elte.hu,
       m.szyprowski@samsung.com, linux-arm-kernel@lists.infradead.org,
       Tomasz Fujak <t.fujak@samsung.com>
Subject: Re: [PATCH/RFC v1 0/2] Human readable performance event
	description in sysfs
Message-ID: <20100120154250.GA27507@n2100.arm.linux.org.uk>
References: <1263978706-15499-1-git-send-email-t.fujak@samsung.com> <1263978999.4283.823.camel@laptop> <op.u6tslipz7p4s8u@pikus> <20100120133145.GE4089@wear.picochip.com> <1263994779.4283.1057.camel@laptop> <20100120135553.GA22897@n2100.arm.linux.org.uk> <1263996080.4283.1064.camel@laptop> <20100120144140.GB22897@n2100.arm.linux.org.uk> <20100120150303.GG4089@wear.picochip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120150303.GG4089@wear.picochip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 03:03:03PM +0000, Jamie Iles wrote:
> On Wed, Jan 20, 2010 at 02:41:40PM +0000, Russell King - ARM Linux wrote:
> > Given that history has shown that identification schemes on ARM change
> > in extremely annoying ways, I don't think decoding these registers to
> > some kind of textual representation for /proc/cpuinfo is the right
> > approach.  It might instead make more sense to just export the entire
> > set of CPU ID registers to userspace, and let userspace grapple with
> > the complexities of decoding the information it wants from them.
> Yes, this would probably be the best generic solution, but in the specific
> case of ARM perfevents, the kernel code already has to decode some of the CPU
> ID registers to work out what set of events to use. Why make userspace do all
> of this decoding again? The x86 code sets up the x86_pmu depending on CPU type
> so this is doing a similar thing (although it is easier for x86).

If you're referring to reading the main CPU ID register and relying
on the part number telling you what CPU you're running on, that's
unreliable if you're only checking the part number - you at least
need to check the implementer.

If you want to do ID checking via the main ID register, there are
some clashes even if you take the implementer field into account.
