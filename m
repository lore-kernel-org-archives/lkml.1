Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZCaNbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZCaNbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbZCaNbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:31:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:60867 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836AbZCaNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:31:37 -0400
Message-ID: <49D21B33.4070406@codemonkey.ws>
Date: Tue, 31 Mar 2009 08:31:31 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 4/4] add ksm kernel shared memory driver.
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <1238457560-7613-2-git-send-email-ieidus@redhat.com> <1238457560-7613-3-git-send-email-ieidus@redhat.com> <1238457560-7613-4-git-send-email-ieidus@redhat.com> <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com>
In-Reply-To: <49D20B63.8020709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
>
> I belive using ioctl for registering memory of applications make it 
> easier....

Yes, I completely agree.

> Ksm doesnt have any complicated API that would benefit from sysfs 
> (beside adding more complexity)
>
>> That is, the KSM_START_STOP_KTHREAD part, not necessarily the rest of 
>> the API.
>
> What you mean?

The ioctl(KSM_START_STOP_KTHREAD) API is distinct from the rest of the 
API.  Whereas the rest of the API is used by applications to register 
their memory with KSM, this API is used by ksmctl to allow parameters to 
be tweaked in userspace.

These parameters are just simple values like enable, pages_to_scan, 
sleep_time.  Then there is KSM_GET_INFO_KTHREAD which provides a read 
interface to these parameters.

You could drop KSM_START_STOP_KTHREAD and KSM_GET_INFO_KTHREAD 
altogether, and introduce a sysfs hierarchy:

/sysfs/<some/path>/ksm/{enable,pages_to_scan,sleep_time}

That eliminates the need for ksmctl altogether, cleanly separates the 
two APIs, and provides a stronger interface.

The main problem with the current API is that it uses a single device to 
do both the administrative task and the userspace interface.  That means 
that any application that has access to registering its memory with KSM 
also has the ability to disable KSM.  That seems like a security concern 
to me since registering a memory region ought to be an unprivileged 
action whereas enabling/disabling KSM ought to be a privileged action.

Regards,

Anthony Liguori

>>
>> Regards,
>>
>> Anthony Liguori
>>
>

