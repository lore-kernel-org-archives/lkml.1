Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbZJFXnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbZJFXnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZJFXnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:43:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:44116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758527AbZJFXnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:43:32 -0400
Message-ID: <4ACBD5D1.9020607@kernel.org>
Date: Wed, 07 Oct 2009 08:42:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 07/19] stop_machine: reimplement without using workqueue
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-8-git-send-email-tj@kernel.org> <200910062006.59755.rusty@rustcorp.com.au>
In-Reply-To: <200910062006.59755.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 06 Oct 2009 23:42:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 1 Oct 2009 05:39:06 pm Tejun Heo wrote:
>> stop_machine() is the only user of RT workqueue.  Reimplement it using
>> kthreads directly and rip RT support from workqueue.  This is in
>> preparation of concurrency managed workqueue.
> 
> Seems reasonable, but:
> 
>>  void stop_machine_destroy(void)
>>  {
>> +	get_online_cpus();
>>  	mutex_lock(&setup_lock);
> 
> Did you test hotplug cpu after this change?  Maybe this works fine, but it's
> always the one we break when we play with this code :(

Yeap, played with it and seems to work fine.

Thanks.

-- 
tejun
