Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbZJARIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbZJARIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZJARIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:08:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:60783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbZJARIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:08:38 -0400
Message-ID: <4AC4E1D7.2070807@kernel.org>
Date: Fri, 02 Oct 2009 02:07:35 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH 06/19] acpi: use queue_work_on() instead of binding workqueue
 worker to cpu0
References: <1254384558-1018-7-git-send-email-tj@kernel.org> <1254384558-1018-1-git-send-email-tj@kernel.org> <9997.1254401851@redhat.com>
In-Reply-To: <9997.1254401851@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 01 Oct 2009 17:07:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> -	kacpid_wq = create_singlethread_workqueue("kacpid");
>> -	bind_workqueue(kacpid_wq);
>> -	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
>> -	bind_workqueue(kacpi_notify_wq);
>> -	kacpi_hotplug_wq = create_singlethread_workqueue("kacpi_hotplug");
>> -	bind_workqueue(kacpi_hotplug_wq);
>> +	kacpid_wq = create_workqueue("kacpid");
>> +	kacpi_notify_wq = create_workqueue("kacpi_notify");
>> +	kacpi_hotplug_wq = create_workqueue("kacpi_hotplug");
> 
> Doesn't that then create one worker thread per CPU and then eschew all but
> those attached to CPU 0?  Sounds excessive, but presumably you deal with that
> in later patches.

Yeah, I'm just trying to strip down odd usages to ease conversion to
new mechanism, so between this patch and the actual new workqueue
implementation there will be whole lot of unused kthreads.  After the
new workqueue, they automatically disappear.  Also, the above can be
cleaned up such that only one of the workqueues remains afterwards.

Thanks.

-- 
tejun
