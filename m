Return-Path: <linux-kernel-owner+w=401wt.eu-S1760842AbZANOuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760842AbZANOuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:50:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbZANOuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:50:00 -0500
Received: from squawk.glines.org ([72.36.206.66]:43577 "EHLO squawk.glines.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbZANOt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:49:59 -0500
Message-ID: <496DFACE.10403@glines.org>
Date: Wed, 14 Jan 2009 06:46:38 -0800
From: Mark Glines <mark@glines.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, L-K <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28 has unconfigurable group sched?
References: <496CDDE9.3050008@glines.org> <1231926992.7141.23.camel@twins>
In-Reply-To: <1231926992.7141.23.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>> So it seems rt_schedulable() is never succeeding.  Any ideas?
> 
> Yeah, I should test this user grouping stuff more often :/
> 
> The below fixes it for me.
> ---
> Subject: sched: fix bandwidth validation for UID grouping 
> 
> For UID grouping we initialize the root group with infinite bandwidth
> which by default is actually more than the global limit, therefore the
> bandwidth check always fails.
> 
> Because the root group is a phantom group (for UID grouping) we cannot
> runtime adjust it, therefore we let it reflect the global bandwidth
> settings.


Thanks.  Sadly, this doesn't seem to change anything for me.  I applied
it to 2.6.28, rebuilt and reinstalled, and got the same result.  I did a
clean rebuild to be sure; and got the same behavior again.

Please let me know if there are any additional diagnostics I can provide.

Mark
