Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0BAQra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:47:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:48231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0BAQr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:47:28 -0500
Subject: Re: [PATCH] perf_events: fix bug in hw_perf_enable()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <bd4cb8901002010812x505b77b4h754f573e3bbfa615@mail.gmail.com>
References: <4b66dc67.0b38560a.1635.ffffae18@mx.google.com>
	 <1265038508.24455.177.camel@laptop>
	 <bd4cb8901002010812x505b77b4h754f573e3bbfa615@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 17:47:17 +0100
Message-ID: <1265042837.24455.234.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 17:12 +0100, Stephane Eranian wrote:
> > btw, I've also added the below, from what I can make from the docs
> fixed
> > counter 2 is identical to arch perf event 0x013c, as per table A-1
> and
> > A-7. Both are called CPU_CLK_UNHALTED.REF, except for Core2, where
> > 0x013c is called CPU_CLK_UNHALTED.BUS.
> >
> 
> If you measure 0x013c in a generic counter or in fixed counter 2
> it will count the same thing but not at the same rate.
> This is true on Core2, Atom, Nehalem, Westmere. The ratio is the
> clock/bus ratio.

But for Nehalem and Westmere event 0x3c umask 0x01 is referred to as
CPU_CLK_UNHALTED.REF_P (Tables A-2 and A-4), 

Fixed Counter 2 is referred to as CPU_CLK_UNHALTED.REF (Table A-7).

For Core2 and Atom (Table A-8, A-9) it is called CPU_CLK_UNHALTED.BUS,
for these entries there is talk about a fixed ratio.

