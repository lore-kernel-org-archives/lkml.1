Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZLVBKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZLVBKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 20:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZLVBKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 20:10:25 -0500
Received: from ozlabs.org ([203.10.76.45]:34969 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbZLVBKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 20:10:23 -0500
Date: Tue, 22 Dec 2009 12:09:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, eranian@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       perfmon2-devel@lists.sf.net, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] perf_events: improve Intel event scheduling
Message-ID: <20091222010941.GC31264@drongo>
References: <1255964630-5878-1-git-send-email-eranian@gmail.com>
 <1258561957.3918.661.camel@laptop>
 <7c86c4470912110300n44650d98ke52ec56cf4d925c1@mail.gmail.com>
 <7c86c4470912110359i5a4416c2t9075eaa47d25865a@mail.gmail.com>
 <1261410040.4314.178.camel@laptop>
 <bd4cb8900912211100n419ef5b1w5322656b034f909e@mail.gmail.com>
 <1261423869.4314.198.camel@laptop>
 <bd4cb8900912211259u4316ec7ak8baf0da77ecd4793@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4cb8900912211259u4316ec7ak8baf0da77ecd4793@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 09:59:45PM +0100, Stephane Eranian wrote:

> Ok, so what you are suggesting is that the assignment is actually done
> incrementally in ->enable(). hw_group_sched_in() would simply validate
> that a single group is sane (i.e., can be scheduled if it was alone).

No, hw_group_sched_in needs to validate that this group can go on
along with everything else that has already been enabled.  But as I
have said, if you have the complete list of enabled events to hand,
that's not hard.

On the other hand, hw_perf_event_init does need to validate that a
single group is sane by itself.

Paul.
