Return-Path: <linux-kernel-owner+w=401wt.eu-S932709Ab0AGJBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab0AGJBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 04:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932597Ab0AGJA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 04:00:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:51678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab0AGJA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 04:00:56 -0500
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100107041340.GA30718@drongo>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
	 <1258561957.3918.661.camel@laptop>
	 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
	 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
	 <1261410040.4314.178.camel@laptop> <20091222010238.GB31264@drongo>
	 <bd4cb8900912290647wa79615bs3ac8618ca36808c3@mail.gmail.com>
	 <20100107041340.GA30718@drongo>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jan 2010 10:00:26 +0100
Message-ID: <1262854826.4049.91.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 15:13 +1100, Paul Mackerras wrote:
> 
> > All the enable and disable calls can be called from NMI interrupt context
> > and thus must be very careful with locks.
> 
> I didn't think the pmu->enable() and pmu->disable() functions could be
> called from NMI context.

I don't think they're called from NMI context either, most certainly not
from the generic code.

The x86 calls the raw disable from nmi to throttle the counter, but all
that (should) do is disable that counter, which is limited to a single
msr write. After that it schedules a full disable by sending a self-ipi.



