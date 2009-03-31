Return-Path: <linux-kernel-owner+w=401wt.eu-S1761278AbZCaPzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761278AbZCaPzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZCaPzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:55:05 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:36322 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466AbZCaPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:55:04 -0400
Message-ID: <49D23CD1.9090208@codemonkey.ws>
Date: Tue, 31 Mar 2009 10:54:57 -0500
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
References: <1238457560-7613-3-git-send-email-ieidus@redhat.com> <1238457560-7613-4-git-send-email-ieidus@redhat.com> <1238457560-7613-5-git-send-email-ieidus@redhat.com> <49D17C04.9070307@codemonkey.ws> <49D20B63.8020709@redhat.com> <49D21B33.4070406@codemonkey.ws> <20090331142533.GR9137@random.random> <49D22A9D.4050403@codemonkey.ws> <20090331150218.GS9137@random.random> <49D23224.9000903@codemonkey.ws> <20090331151845.GT9137@random.random>
In-Reply-To: <20090331151845.GT9137@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Mar 31, 2009 at 10:09:24AM -0500, Anthony Liguori wrote:
>   
>> I don't think the registering of ram should be done via sysfs.  That would 
>> be a pretty bad interface IMHO.  But I do think the functionality that 
>> ksmctl provides along with the security issues I mentioned earlier really 
>> suggest that there ought to be a separate API for control vs. registration 
>> and that control API would make a lot of sense as a sysfs API.
>>
>> If you wanted to explore alternative APIs for registration, madvise() seems 
>> like the obvious candidate to me.
>>
>> madvise(start, size, MADV_SHARABLE) seems like a pretty obvious API to me.
>>     
>
> madvise to me would sound appropriate, only if ksm would be always-in,
> which is not the case as it won't even be built if it's configured to
> N.
>   

You can still disable ksm and simply return ENOSYS for the MADV_ flag.  
You could even keep it as a module if you liked by separating the 
madvise bits from the ksm bits.  The madvise() bits could just provide 
the tracking infrastructure for determine which vmas were currently 
marked as sharable.

You could then have ksm as loadable module that consumed that interface 
to then perform scanning.

> Besides madvise is sus covered syscall, and this is linux specific detail.
>   

A number of MADV_ flags are Linux specific (like MADV_DOFORK/MADV_DONTFORK).

Regards,

Anthony Liguori
