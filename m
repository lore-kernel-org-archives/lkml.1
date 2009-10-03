Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZJCC7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZJCC7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZJCC7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:59:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58443 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbZJCC7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:59:19 -0400
Date: Sat, 3 Oct 2009 04:59:22 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jeff@garzik.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, ar@firstfloor.org
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed workqueue
Message-ID: <20091003025922.GP1656@one.firstfloor.org>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-20-git-send-email-tj@kernel.org> <87ws3esk1m.fsf@basil.nowhere.org> <4AC5ED72.7090201@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC5ED72.7090201@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One thing is that for userspace there's already pretty thick layer of
> abstraction in place and having this type of bare metal mechanism
> might not buy much.  In most cases, monitoring system parameters

That can be costly in terms of power/cpu cycles.

> periodically and supplying a bit of extra threads should be able to
> achieve about the same result.  Do you have anything specific on your
> mind?

I was thinking of a special file descriptor that could be polled on.
Register threads to be monitored and get a notification back this
way when they are busy above some threshold. Then a runtime could
start more threads upto the maximum number of cores. This would
be mainly useful with existing work distributing libraries 
like threadbuildingblocks.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
