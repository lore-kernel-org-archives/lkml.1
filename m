Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992Ab0ARPZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0ARPZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781Ab0ARPZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:25:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:46335 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0ARPZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:25:49 -0500
Date: Mon, 18 Jan 2010 07:25:23 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative
 implementation
Message-ID: <20100118072523.2683cd59@linux.intel.com>
In-Reply-To: <4B5420A3.3080200@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-33-git-send-email-tj@kernel.org>
	<20100117220130.214d56f1@linux.intel.com>
	<4B5420A3.3080200@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 17:49:39 +0900
Tejun Heo <tj@kernel.org> wrote:

> For what async is currently used for, I don't think there will be any
> noticeable difference.  If the proposed implementation is lacking
> somewhere, we can definitely improve it although I'm not sure whether
> it will end up with the cookie thing.

it is not that I do not like your backend implementation. I do not like
the programming model change you're introducing.
The cookie API allows for what is sort of the equivalent of out-of-order
execution that the cpu does. In a very very simple way, you can start
things in an order, then they execute in variable times and in parallel,
and then when the side effects need to become visible (device
registration, whatever), you go back to an in-order model. 
I have patches to do this for KMS and we're working on getting
something working for ACPI as well.

Your API/model change gets rid of this conceptually simple programming
model, which makes using it on other places more complex and messy. I
do not see what enormous benefit your patches would have that would
justify complicating the programming model. (And "sharing the thread
pool" is not that; I'm sure it's possible to share the thread pool
without changing the programming model... and it's not that the async
thread pools are that big or complex anyway)

So consider the current patches

NAK-ed-by: Arjan van de Ven <arjan@linux.intel.com>

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
