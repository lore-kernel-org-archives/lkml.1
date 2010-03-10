Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0CJOyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:54:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756665Ab0CJOyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:54:45 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1267187000-18791-1-git-send-email-tj@kernel.org>
References: <1267187000-18791-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
Date: Wed, 10 Mar 2010 14:52:51 +0000
Message-ID: <29029.1268232771@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 * queue_work - queue work on a workqueue
 * @wq: workqueue to use
 * @work: work to queue
 *
 * Returns 0 if @work was already on a queue, non-zero otherwise.
 *
 * We queue the work to the CPU on which it was submitted, but if the CPU dies
 * it can be processed by another CPU.

So when a work item is running on a CPU, any work items it queues (including
requeueing itself) will be queued upon that CPU for attention only by that CPU
(assuming that CPU doesn't get pulled out)?

David
