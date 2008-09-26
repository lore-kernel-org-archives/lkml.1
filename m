Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYIZP4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYIZP4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYIZP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:56:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:19966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYIZP4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:56:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xXrabJmGB0jlTu79M1Ty2vNxT/ERhZERYkKUKujVlQbilYkob5lfku4q3gBzhfNyoB
         lsMvLpXLjdp3XJFfaT44A42PBSbFWNYXwmvtNP13rXG/8a/Lb82eB0UPUVtMbKnCzdOU
         wRyYDlhV+pIO3cqGXfb3xKPscCPr7vGJrMv5A=
Message-ID: <48DD0617.3050403@gmail.com>
Date: Fri, 26 Sep 2008 17:56:07 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Hirokazu Takahashi <taka@valinux.co.jp>
CC: vgoyal@redhat.com, ryov@valinux.co.jp, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp,
       balbir@linux.vnet.ibm.com, xemul@openvz.org, agk@sourceware.org,
       jens.axboe@oracle.com
Subject: Re: dm-ioband + bio-cgroup benchmarks
References: <20080922143042.GA19222@redhat.com>	<20080924.193414.22923673.taka@valinux.co.jp>	<20080924145331.GD547@redhat.com> <20080926.220418.83079316.taka@valinux.co.jp>
In-Reply-To: <20080926.220418.83079316.taka@valinux.co.jp>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hirokazu Takahashi wrote:
> Hi,
> 
>>>>> It's possible the algorithm of dm-ioband can be placed in the block layer
>>>>> if it is really a big problem.
>>>>> But I doubt it can control every control block I/O as we wish since
>>>>> the interface the cgroup supports is quite poor.
>>>> Had a question regarding cgroup interface. I am assuming that in a system,
>>>> one will be using other controllers as well apart from IO-controller.
>>>> Other controllers will be using cgroup as a grouping mechanism.
>>>> Now coming up with additional grouping mechanism for only io-controller seems
>>>> little odd to me. It will make the job of higher level management software
>>>> harder.
>>>>
>>>> Looking at the dm-ioband grouping examples given in patches, I think cases
>>>> of grouping based  in pid, pgrp, uid and kvm can be handled by creating right
>>>> cgroup and making sure applications are launched/moved into right cgroup by
>>>> user space tools. 
>>> Grouping in pid, pgrp and uid is not the point, which I've been thinking
>>> can be replaced with cgroup once the implementation of bio-cgroup is done.
>>>
>>> I think problems of cgroup are that they can't support lots of storages
>>> and hotplug devices, it just handle them as if they were just one resource.
>>> I don't insist the interface of dm-ioband is the best. I just hope the
>>> cgroup infrastructure support this kind of resources.
>>>
>> Sorry, I did not understand fully. Can you please explain in detail what
>> kind of situation will not be covered by cgroup interface.
> 
> From the concept of the cgroup, if you want control several disks
> independently, you should make each disk have its own cgroup subsystem,
> which only can be defined when compiling the kernel. This is impossible
> because every linux box has various number of disks.

mmh? not true. You can define a single cgroup subsystem that implements
the opportune interfaces to apply your type of control, and use many
structures allocated dynamically for each controlled object (one for
each block device, disk, partition, ... or using any kind of
grouping/splitting policy). Actually, this is how cgroup-io-throttle, as
well as any other cgroup subsystem, is implemented.

> So you think it may be possible to make each cgroup have lots of control
> files for each device as a workaround. But it isn't allowed to add/remove
> control files when some devices are hot-added or hot-removed.

Why not a single control file for all the devices?

-Andrea
