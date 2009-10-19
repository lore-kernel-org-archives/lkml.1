Return-Path: <linux-kernel-owner+w=401wt.eu-S1751152AbZJSApJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152AbZJSApJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 20:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZJSApI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 20:45:08 -0400
Received: from ozlabs.org ([203.10.76.45]:36378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbZJSApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 20:45:07 -0400
Date: Mon, 19 Oct 2009 11:42:26 +1100
From: Anton Blanchard <anton@samba.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] powerpc perf_event: Add alignment-faults and
	emulation-faults software events
Message-ID: <20091019004226.GT4808@kryten>
References: <20091018110929.GK4808@kryten> <20091018111126.GL4808@kryten> <20091018111300.GM4808@kryten> <1255909805.4192.5.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255909805.4192.5.camel@concordia>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> > +#define PPC_WARN_ALIGNMENT(type, regs)				\
> > +	do {								\
> > +		perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS,		\
> > +			1, 0, regs, regs->dar);				\
> > +		__PPC_WARN_EMULATED(type);				\
> > +	} while (0)
> 
> Does that work with perfxxx configured off?

Yeah, perf_event.h defines an empty version if its configured off:

static inline void
perf_sw_event(u32 event_id, u64 nr, int nmi,
                     struct pt_regs *regs, u64 addr)                    { }

Anton
