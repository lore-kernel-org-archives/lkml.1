Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbXKHGAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbXKHGAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 01:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXKHGAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 01:00:32 -0500
Received: from mail.davidb.org ([66.93.32.219]:55096 "EHLO mail.davidb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbXKHGAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 01:00:32 -0500
Date: Wed, 7 Nov 2007 22:00:29 -0800
From: David Brown <lkml@davidb.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>,
       Michael Kerrisk <mtk-manpages@gmx.net>
Subject: Re: compat_sys_times() bogus until jiffies >= 0.
Message-ID: <20071108060029.GB3307@old.davidb.org>
References: <20071107224722.GA20204@old.davidb.org> <20071107152833.6f302c2a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20071107152833.6f302c2a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 03:28:33PM -0800, Andrew Morton wrote:
>> On Wed, 7 Nov 2007 14:47:22 -0800 David Brown <lkml@davidb.org> wrote:

>> will return '-1' to user space and set the negated clock_t value to errno.
>>
>> At minimum, perhaps it should return a sane errno value.
>
>RETURN VALUE
>       times()  returns  the  number of clock ticks that have elapsed since an
>       arbitrary point in the past.  For Linux 2.4 and earlier this  point  is
>       the  moment  the  system  was  booted.   Since Linux 2.6, this point is
>       (2^32/HZ) - 300 (i.e., about 429 million) seconds  before  system  boot
>       time.   The  return  value  may  overflow  the  possible  range of type
>       clock_t.  On error, (clock_t) -1 is returned, and errno is  set  appro-
>       priately.

The strange -1 behavior is enshrined in history.  I think a better answer
is to tell people to use getrusage() if they want a return result without
this problem.

Adding INITIAL_JIFFIES will fix the case where an embedded system is booted
up to run a test and then shut down, and the mask, although it causes
discontinuities periodically at least moves them away from the early boot.

INITIAL_JIFFIES was a good idea, but it is probably best to keep it inside
of the kernel.

David Brown
