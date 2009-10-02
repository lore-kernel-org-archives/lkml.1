Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZJBLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZJBLqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZJBLqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 07:46:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:33190 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbZJBLqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 07:46:18 -0400
Message-ID: <4AC5E7BA.5060700@kernel.org>
Date: Fri, 02 Oct 2009 20:44:58 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [RFC PATCHSET] workqueue: implement concurrency managed workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <9942.1254401629@redhat.com>
In-Reply-To: <9942.1254401629@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 11:45:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David Howells.

David Howells wrote:
> Sounds interesting as a replacement for slow-work.  Some thoughts for you:
> 
> The most important features of slow-work are:
> 
>  (1) Work items are not re-entered whilst they are executing.
> 
>  (2) The slow-work facility keeps references on its work items by asking the
>      client to get and put on the client's refcount.
> 
>  (3) The slow-work facility can create a lot more threads than the number of
>      CPUs on a system, and the system doesn't grind to a halt if they're all
>      taken up with long term I/O (performing several mkdirs for example).
> 
> I think you have (1) and (3) covered, but I'm unsure about (2).

Given that slow-work isn't being used too extensively yet, I was
thinking whether that part could be pushed down to the caller.  Or, we
can also wrap work and export an interface which supports the get/put
reference.

> Also, does it actually make sense to bind threads that are
> performing long-term I/O to particular CPUs?  Threads that are going
> to spend a lot more time sleeping on disk I/O than actually running
> on a CPU?

Binding is usually beneficial and doesn't matter for IO intensive
ones, so...

Thanks.

-- 
tejun
