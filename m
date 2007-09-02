Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbXIBI7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbXIBI7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 04:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbXIBI7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 04:59:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbXIBI7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 04:59:33 -0400
Message-ID: <46DA7A4C.6080501@zytor.com>
Date: Sun, 02 Sep 2007 09:54:36 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Andi Kleen <andi@firstfloor.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com> <200708301432.11516.rob@landley.net> <p73lkbqvxp8.fsf@bingen.suse.de> <200709020344.51437.rob@landley.net>
In-Reply-To: <200709020344.51437.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> On Saturday 01 September 2007 5:16:03 pm Andi Kleen wrote:
>> Rob Landley <rob@landley.net> writes:
>>> A lot of embedded people like to configure /proc out of the kernel for
>>> space reasons.  This would make that noticeably more painful.
>> I had a patch for a sysctl_name(2) for this a long time ago.
>> If it was a serious issue that could be reintroduced.
>>
>> BTW sysctl(2) only needs to be quiet for a single sysctl used
>> by glibc.
>>
>> -Andi
> 
> Yeah, I found it:
> http://lkml.org/lkml/2003/7/10/345
> 
> I think that if /proc/sys could be broken out as a separate filesystem, and it 
> was small and simple, the embedded people would probably be happy.  Is your 
> patch significantly smaller than such a filesystem would be?  (Keeping in 
> mind that the smallest thing you can do is run from initramfs, and I think 
> that's pulling in libfs already...)
> 

IMO, the big problem with /proc/sys (and, for that matter, /sys) is 
mainly that they have to live in the process namespace, which is highly 
awkward when one uses chroot().

One way to solve *that* might be a system call to get a file descriptor 
to the root of sysfs or procsysfs which can be used with openat().  That 
has its own perils, of course...

	-hpa
