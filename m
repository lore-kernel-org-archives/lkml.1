Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155Ab0ARGBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab0ARGBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 01:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033Ab0ARGBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 01:01:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:47258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0ARGBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 01:01:45 -0500
Date: Sun, 17 Jan 2010 22:01:30 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative
 implementation
Message-ID: <20100117220130.214d56f1@linux.intel.com>
In-Reply-To: <1263776272-382-33-git-send-email-tj@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-33-git-send-email-tj@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 09:57:44 +0900
Tejun Heo <tj@kernel.org> wrote:

> Now that cmwq can handle high concurrency, there's no reason to
> implement separate thread pool for async.  Introduce alternative
> implementation based on workqueue.
> 


I'm sorry but I'm really not happy with this conversion;
it looses the very nice property of being able to execute and
synchronize between places at the end just before device registration.

I don't mind the implementation sharing thread pool with your stuff,
but I really really want to keep the cookie and synchronization
mechanism. There's a bunch of users of that pending and doing things
sequential entirely just is not going to cut it.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
