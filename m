Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZLUDRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZLUDRi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 22:17:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbZLUDRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 22:17:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:34157 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbZLUDRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 22:17:36 -0500
Message-ID: <4B2EE93F.40904@kernel.org>
Date: Mon, 21 Dec 2009 12:19:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com>
In-Reply-To: <4B2B9949.1000608@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/19/2009 12:01 AM, Arjan van de Ven wrote:
> in addition, threads are cheap. Linux has no technical problem with
> running 100's of kernel threads (if not 1000s); they cost basically
> a task struct and a stack (2 pages) each and that's about it.
> making an elaborate-and-thus-fragile design to save a few kernel
> threads is likely a bad design direction...

A resource not being scarce is very different from a resource being
limitless and doesn't mean we can use them without thinking about it.
If we haven't been trying to limit the number of threads used by
various subsystems, we could easily be looking at far larger number of
threads than we're using now and things would be breaking at the far
ends of the spectrum (very small or extremely large systems).

What cmwq does is managing this not-so-scarce resource automatically
at a single place and because the resource is not so scarce, it can be
made very mechanical and reliable.  No need to worry about managing
concurrencies or limit the number of threads from other places.  Sure,
it involves some amount of complex code in implementing workqueue
itself but we'll be removing a lot of complexities and codes from more
peripheral places and that is the right direction to go.  We can
easily get the core code right and after being properly debugged, cmwq
won't be fragile.  As an async mechanism, its operation is highly
deterministic and mechanical.

Thanks.

-- 
tejun
