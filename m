Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZJAM5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZJAM5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 08:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755524AbZJAM5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 08:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZJAM5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 08:57:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1254384558-1018-1-git-send-email-tj@kernel.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed workqueue
Date: Thu, 01 Oct 2009 13:53:49 +0100
Message-ID: <9942.1254401629@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sounds interesting as a replacement for slow-work.  Some thoughts for you:

The most important features of slow-work are:

 (1) Work items are not re-entered whilst they are executing.

 (2) The slow-work facility keeps references on its work items by asking the
     client to get and put on the client's refcount.

 (3) The slow-work facility can create a lot more threads than the number of
     CPUs on a system, and the system doesn't grind to a halt if they're all
     taken up with long term I/O (performing several mkdirs for example).

I think you have (1) and (3) covered, but I'm unsure about (2).

Also, does it actually make sense to bind threads that are performing
long-term I/O to particular CPUs?  Threads that are going to spend a lot more
time sleeping on disk I/O than actually running on a CPU?

David
