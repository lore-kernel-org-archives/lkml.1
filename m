Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0CLL0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:26:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab0CLL0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:26:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B99CB0F.1090505@kernel.org>
References: <4B99CB0F.1090505@kernel.org> <1267187000-18791-1-git-send-email-tj@kernel.org> <29029.1268232771@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       oleg@redhat.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#4
Date: Fri, 12 Mar 2010 11:23:55 +0000
Message-ID: <3491.1268393035@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> > So when a work item is running on a CPU, any work items it queues
> > (including requeueing itself) will be queued upon that CPU for attention
> > only by that CPU (assuming that CPU doesn't get pulled out)?
> 
> Yes, that's the one of the characteristics of workqueue.  For IO bound
> stuff, it usually is a plus.

Hmmm.  So when, say, an FS-Cache index object finishes creating itself on disk
and then releases all the several thousand data objects waiting on that event
so that they can then create themselves, it will do this by calling
queue_work() on each of them in turn.  I take it this will stack them all up on
that one CPU's work queue.

David
