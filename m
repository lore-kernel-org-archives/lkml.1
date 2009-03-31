Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbZCaOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbZCaOhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbZCaOh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:37:27 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:7347 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZCaOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:37:26 -0400
Message-ID: <49D22A9D.4050403@codemonkey.ws>
Date: Tue, 31 Mar 2009 09:37:17 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Izik Eidus <ieidus@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, linux-mm@kvack.org, avi@redhat.com,
       chrisw@redhat.com, riel@redhat.com, jeremy@goop.org,
       mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net, yaniv@redhat.com,
       dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <1238457560-7613-2-git-send-email-ieidus@redhat.com> <1238457560-7613-3-git-send-email-ieidus@redhat.com> <1238457560-7613-4-git-send-email-ieidus@redhat.com> <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random>
In-Reply-To: <20090331142533.GR9137@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:

>> the ability to disable KSM.  That seems like a security concern to me since 
>> registering a memory region ought to be an unprivileged action whereas 
>> enabling/disabling KSM ought to be a privileged action.
>>     
>
> sysfs files would then only be writeable by admin, so if we want to
> allow only admin to start/stop/tune ksm it'd be enough to plug an
> admin capability check in the ioctl to provide equivalent permissions.
>   

Caps are not very granular unless you introduce a new capability.  
Furthermore, it's a bit more difficult to associate a capability with a 
user/group.

With sysfs, you use file based permissions to control the API.  It also 
fits into things like selinux a lot better.

In the very least, if you insist on not using sysfs, you should have a 
separate character device that's used for control (like /dev/ksmctl).

Regards,

Anthony Liguori

> I could imagine converting the enable/pages_to_scan/sleep_time to
> module params and tweaking them through /sys/module/ksm/parameters,
> but for "enable" to work that way, we'd need to intercept the write so
> we can at least weakup the kksmd daemon, which doesn't seem possible
> with /sys/module/ksm/parameters, so in the end if we stick to the
> ioctl for registering regions, it seems simpler to use it for
> start/stop/tune too.
>   

