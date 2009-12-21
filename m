Return-Path: <linux-kernel-owner+w=401wt.eu-S1751692AbZLUNXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbZLUNXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 08:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZLUNXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 08:23:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:52916 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZLUNX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 08:23:29 -0500
Message-ID: <4B2F768C.1040704@kernel.org>
Date: Mon, 21 Dec 2009 22:22:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <4B2F57E6.7020504@linux.intel.com>
In-Reply-To: <4B2F57E6.7020504@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/21/2009 08:11 PM, Arjan van de Ven wrote:
> I don't mind a good and clean design; and for sure sharing thread
> pools into one pool is really good.  But if I have to choose between
> a complex "how to deal with deadlocks" algorithm, versus just
> running some more threads in the pool, I'll pick the later.

The deadlock avoidance algorithm is pretty simple.  It creates a new
worker when everything is blocked.  If the attempt to create a new
worker blocks, it calls in dedicated workers to ensure allocation path
is not blocked.  It's not that complex.

Thanks.

-- 
tejun
