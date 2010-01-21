Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873Ab0AUI7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0AUI7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 03:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816Ab0AUI7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 03:59:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0AUI7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 03:59:35 -0500
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>
In-Reply-To: <7c86c4471001210047v5907f9d8ncecc1f5441afab3a@mail.gmail.com>
References: <4B560ACD.4040206@linux.vnet.ibm.com>
	 <1263994448.4283.1052.camel@laptop> <1264023204.4283.1124.camel@laptop>
	 <7c86c4471001210047v5907f9d8ncecc1f5441afab3a@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 09:59:04 +0100
Message-ID: <1264064344.4283.1136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 09:47 +0100, stephane eranian wrote:
> I don't think that is correct. You can be using the uncore PMU on Nehalem
> without any core PMU event. The only thing to realize is that uncore PMU
> shares the same interrupt vector as core PMU. You need to configure which
> core the uncore is going to interrupt on. This is done via a bitmask, so you
> can interrupt more than one core at a time. Several strategies are possible.

Ah, sharing the IRQ line is no problem. But from reading I got the
impression you need to configure an Offcore counter. See 30.6.2.1:

• EN_PMI_COREn (bit n, n = 0, 3 if four cores are present): When set, processor
core n is programmed to receive an interrupt signal from any interrupt enabled
uncore counter. PMI delivery due to an uncore counter overflow is enabled by
setting IA32_DEBUG_CTL.Offcore_PMI_EN to 1.

Which seems to indicate a link with the off-core response thing.

However I would be very glad to be wrong :-)

