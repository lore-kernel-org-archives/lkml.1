Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYJRBbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYJRBbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 21:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbYJRBbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 21:31:45 -0400
Received: from mail.lang.hm ([64.81.33.126]:59641 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYJRBbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 21:31:44 -0400
Date: Fri, 17 Oct 2008 18:32:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Giacomo A. Catenazzi" <cate@cateee.net>
cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
In-Reply-To: <48F88923.30109@cateee.net>
Message-ID: <alpine.DEB.1.10.0810171826480.11079@asgard.lang.hm>
References: <20081016002509.GA25868@kroah.com> <48F88923.30109@cateee.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008, Giacomo A. Catenazzi wrote:

> Greg KH wrote:
>> We number the kernel based on the year, and the numbers of releases we
>> have done this year:
>> 	YEAR.NUMBER.MINOR_RELEASE
>> 
>> For example, the first release in 2009 would be called:
>> 	2009.0.0
>> The second:
>> 	2009.1.0
>> 
>> If we want to be a bit more "non-zero-counting" friendly: we can start
>> at "1" for the number:
>> 	2009.1.0 for the first release
>> 	2009.2.0 for the second.
>> 
>> Then the stable releases can increment the minor number:
>> 	2009.1.1 for the first stable release
>> 	2009.1.2 for the second.
>> 	and so on.
>> 
>> Benefits of this is it more accuratly represents to people just how old
>> the kernel they are currently running is (2.6.9 would be have been
>> 2004.9.0 on this naming scheme.)
>> 
>> Yes, we can handle the major/minor macros in the kernel to provide a
>> compatible number so that automated scripts will not break, that's not a
>> big deal.
>> 
>> Any thoughts?
>
> What about:
> - rc releases: a 2009.5.0-rc4 become suddenly 2010.0.0-rc5 ?

three options

1. change it as you state based on it slipping

2. 2009.5.0-rc4 goes to 2009.5.0-rc5 in January and we just accept a minor 
'oops' on the version number

3. 2009.5.0-rc4 goes to 2009.5.0-rc5 in January becouse we base the number 
on when the merge window opened, not when it's released.

personally I think 3 is the clearest to explain to people, but I don't 
like 1 (it's not that bad, but it leaves a lot of mail in archives and bug 
reports listing the 2009.5.0 version number when no such version was ever 
released)

> - a stable version in January of a kernel released in December
>  still has the old year? (I hope yes, but it could confuse users.)

absolutly, the stable version is the Nth revision of the kernel that was 
released in December, it doesn't matter when the stable release happened 
(similar to the 2.6.16.X kernels that have been released)

> - when (if) we need a big innovative (or incompatible) kernel
>  change, how to mark old and new kernels?

they are marked in the release announcemnts, and code that cares can do 
'is version > 2009.5' logic.

this sort of test is done today by software so that they can enable better 
functionality on newer kernels, the size of the difference shouldn't 
matter.

David Lang

