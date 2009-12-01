Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZLAOvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZLAOvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 09:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZLAOvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 09:51:49 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34057 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZLAOvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 09:51:49 -0500
Date: Tue, 1 Dec 2009 14:53:05 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jamie Iles <jamie@jamieiles.com>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: Perf events/ARM
Message-ID: <20091201145305.GC4061@wear.picochip.com>
References: <20091201120439.GB4061@wear.picochip.com> <20091201143105.GB1183@elte.hu> <1259678444.1697.487.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259678444.1697.487.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pete, Ingo,

On Tue, Dec 01, 2009 at 03:40:44PM +0100, Peter Zijlstra wrote:
> Things like wakeups and ->event_limit might get delayed.
> 
> Delayed wakeups can be mitigated by larger buffers, delayed disable on
> ->event_limit is not something you can fix up.
> 
> Does your PMU generate regular interrupts or actual NMIs? If its normal
> interrupts you can simply call perf_event_do_pending() at the
> pmu-interrupt tail.
The PMU generates regular interrupts and in the case of the platform I'm
working on these go to a regular vectored interrupt controller all sharing the
same vector. So I'll add a call to perf_event_do_pending() at the tail of the
PMU IRQ and leave set_perf_event_pending() as a nop.

Thanks,

Jamie
