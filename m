Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968Ab0ASAxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0ASAxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030Ab0ASAxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:53:01 -0500
Received: from hera.kernel.org ([140.211.167.34]:48878 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679Ab0ASAxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:53:00 -0500
Message-ID: <4B55038D.3070106@kernel.org>
Date: Tue, 19 Jan 2010 09:57:49 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org> <20100118072523.2683cd59@linux.intel.com>
In-Reply-To: <20100118072523.2683cd59@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 00:51:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Arjan.

On 01/19/2010 12:25 AM, Arjan van de Ven wrote:
> Your API/model change gets rid of this conceptually simple programming
> model, which makes using it on other places more complex and messy. I
> do not see what enormous benefit your patches would have that would
> justify complicating the programming model. (And "sharing the thread
> pool" is not that; I'm sure it's possible to share the thread pool
> without changing the programming model... and it's not that the async
> thread pools are that big or complex anyway)

Oh yeah, if you want the cookies, it can be implemented on top of
workqueue.  I'm just not sure whether that has justifiable benefit.
About the same things can be achived using flushes and if some
subsystem want low level control, it can simply use the workqueue
directly implementing whatever level of concurrency as it sees fit and
flushing as necessary.

As cmwq can provide async contexts flexibly, the benefit of async is
simplification of simple cases where the caller doesn't have to worry
about allocating works or whatever.  I don't really see much point in
introducing a different set of sync rules based on cookies when the
same thing can be achieved using wq interfaces directly and I think
that having two different models for async synchronization might hurt
more than help.  What type of ordering rules are you currently working
on using cookies?

Thanks.

-- 
tejun
