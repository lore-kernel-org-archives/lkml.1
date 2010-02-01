Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0BAM1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 07:27:10 -0500
Received: from casper.infradead.org ([85.118.1.10]:54281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab0BAM1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 07:27:09 -0500
Subject: Re: [BUG] perf_events: ctx_flexible_sched_in()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: eranian@gmail.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net
In-Reply-To: <bd4cb8901002010420o2ea7dbafnba84f78b6a2f38f5@mail.gmail.com>
References: <bd4cb8901002010420o2ea7dbafnba84f78b6a2f38f5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 13:27:03 +0100
Message-ID: <1265027223.24455.145.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 13:20 +0100, Stephane Eranian wrote:
> The function does not allow maximizing PMU usage because of
> the way can_add_hw is managed. Basically, as soon as a group
> fail to be scheduled in, then no other group can. I believe this
> is not optimum. You need to skip the group that fails and keep
> scanning the list. There may be other groups which can be
> scheduled.

Yeah, I saw that too, we need a new hw_ callback for that, or more
structured error values out of ->enable that distinguish between this
event won't fit and pmu full.

