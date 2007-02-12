Return-Path: <linux-kernel-owner+w=401wt.eu-S964951AbXBLQji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951AbXBLQji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964961AbXBLQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:39:37 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:41834 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951AbXBLQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:39:36 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated
	patch
From: Carl Love <cel@us.ibm.com>
To: Milton Miller <miltonm@bga.com>
Cc: cbe-oss-dev@ozlabs.org, Arnd Bergmann <arnd@arndb.de>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net
In-Reply-To: <fdeac69371a6b75fbf0ebffd30228106@bga.com>
References: <1170721711.5204.44.camel@dyn9047021078.beaverton.ibm.com>
	 <1170802957.5204.56.camel@dyn9047021078.beaverton.ibm.com>
	 <b682962303654f4958a6c2c50d805907@bga.com>
	 <200702081821.57358.arnd@arndb.de>
	 <1170975119.5204.99.camel@dyn9047021078.beaverton.ibm.com>
	 <e03c784bc3aff642ef10d0e2ed8eab45@bga.com>
	 <1171037869.5204.143.camel@dyn9047021078.beaverton.ibm.com>
	 <fdeac69371a6b75fbf0ebffd30228106@bga.com>
Content-Type: text/plain
Date: Mon, 12 Feb 2007 08:38:35 -0800
Message-Id: <1171298315.5204.235.camel@dyn9047021078.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-11 at 16:46 -0600, Milton Miller wrote:

[cut]

> 
> As far as I understand, you are providing access to a completely new
> hardware that is related to the PMU hardware by the fact that it
> collects a program counter.   It doesn't use the PMU counters nor the
> PMU event selection.
> 
> In fact, why can the existing op_model_cell profiling not run while
> the SPU profiling runs?   Is there a shared debug bus inside the
> chip?   Or just the data stream with your buffer_sync code?
> 

There are two reasons you cannot do SPU profiling and profiling on non
SPU events at the sametime.  1) the SPU PC values are routed on the
debug bus.  You cannot also route the signals for other non SPU events
on the debug bus since they will conflict.  Specifically, the signals
would get logically OR'd on the bus.  The exception is PPU cycles which
does not use the debug bus.  2) the hardware that captures the SPU
program counters has some shared components with the HW performance
counters.  To use the SPU program counter hardware, the performance
counter hardware must be disabled.

In summary, we cannot do SPU cycle profiling and non SPU event profiling
at the same time due to limitations in the hardware.


[cut]


> milton
> 

