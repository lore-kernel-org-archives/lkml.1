Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab0BNMig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 07:38:36 -0500
Received: from casper.infradead.org ([85.118.1.10]:34184 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0BNMif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 07:38:35 -0500
Subject: Re: Why is PERF_FORMAT_GROUP incompatible with inherited events?
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, Dave Wootton <dwootton@us.ibm.com>
In-Reply-To: <20100214113314.GG13769@brick.ozlabs.ibm.com>
References: <20100212030205.GE13769@brick.ozlabs.ibm.com>
	 <1266142337.5273.417.camel@laptop>
	 <20100214113314.GG13769@brick.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 13:38:27 +0100
Message-ID: <1266151107.5273.629.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 22:33 +1100, Paul Mackerras wrote:
> 
> But we don't go and collect the count delta from children without
> PERF_FORMAT_GROUP, so why would we with it? 

Yes we do, see perf_event_read_value().

But now that I look at it we don't seem to do so in
perf_output_read_one()... I guess we should fix that.

There is of course the lock inversion in the .read() code reported by
stephane, but other than that is seems to actually support inherited &&
group just fine.

So I think if we fix that lock inversion and make the PERF_SAMPLE_READ
code look like the .read() code it should all work out.



