Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab0BRLvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:51:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397Ab0BRLvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:51:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B7B2F4E.5090803@kernel.org>
References: <4B7B2F4E.5090803@kernel.org> <4B7A13C6.4060402@kernel.org> <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com> <27102.1266246296@redhat.com> <28151.1266343557@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead of slow-work
Date: Thu, 18 Feb 2010 11:50:16 +0000
Message-ID: <26902.1266493816@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> The waiting workers are woken up in slow_work_enqueue() when a new
> work is enqueued regardless of how many workers are currently in use,
> right?  So, it ends up yielding on any queue activity rather than only
> under resource pressure.

It depends how you define resource pressure, I suppose.  There's someone now
waiting for the resource, and there's someone blocking that resource who can
yield it as they're waiting on something else.  The question is if it's
cheaper to create a new thread, assuming we're under the limit, or if it's
cheaper to steal someone else's thread?

David
