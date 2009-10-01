Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbZJANSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbZJANSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 09:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbZJANSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 09:18:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbZJANSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 09:18:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1254384558-1018-20-git-send-email-tj@kernel.org>
References: <1254384558-1018-20-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
Date: Thu, 01 Oct 2009 14:15:26 +0100
Message-ID: <10231.1254402926@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> gcwq always keeps at least single idle worker around.  When a new
> worker is necessary and the worker is the last idle one, the worker
> assumes the role of "manager" and manages the worker pool -
> ie. creates another worker.  Forward-progress is guaranteed by having
> dedicated rescue workers for workqueues which may be necessary while
> creating a new worker.  When the manager is having problem creating a
> new worker, mayday timer activates and rescue workers are summoned to
> the cpu and execute works which may be necessary to create new
> workers.

I take it that means that the rescue-workers are donated to the pool to become
worker threads (perhaps on a temporary basis) in the event that forking fails
due to ENOMEM, such that resources can be freed up for fork() to use.

David
