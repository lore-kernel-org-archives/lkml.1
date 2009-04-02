Return-Path: <linux-kernel-owner+w=401wt.eu-S1765983AbZDBRxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765983AbZDBRxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbZDBRxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:53:30 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:41261 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbZDBRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:53:29 -0400
Message-ID: <49D4FB89.4070101@nortel.com>
Date: Thu, 02 Apr 2009 11:53:13 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, peterz@infradead.org,
       akpm@linux-foundation.org
Subject: Re: Resend: /proc/<pid>/maps offset output broken in 2.6.29
References: <49CA8501.1000000@nortel.com>  <49D3F662.4050100@nortel.com> <1238659491.9041.133.camel@localhost> <Pine.LNX.4.64.0904021324070.16207@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904021324070.16207@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2009 17:53:15.0663 (UTC) FILETIME=[E60CE1F0:01C9B3BB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 2 Apr 2009, Michael Ellerman wrote:
>> On Wed, 2009-04-01 at 17:18 -0600, Chris Friesen wrote:
>>> Resending due to lack of response to original post.
>> Hi Chris,
>>
>> You'll probably get a more useful response on lkml. You CC'ed
>> linux-kernel-owner originally :)
> 
> Thanks.

Thanks from me too.  (Oops.)

>>> I was validating some code dealing with /proc/<pid>/maps on 2.6.29 and 
>>> was surprised when it failed.  It turns out that at least on my ppc64 G5 
>>> machine the offset value for the last entry is strange--it shows up as a 
>>> 64-bit value even though the process itself is only 32-bit.
>>>
>>> This behaviour also shows up in 2.6.25, but doesn't in 2.6.14.  I 
>>> haven't yet tested anything else in between.
>>>
>>> [cfriesen@localhost cfriesen]$ cat /proc/self/maps
>>> 00100000-00103000 r-xp 00100000 00:00 0         [vdso]
>>> 0fe70000-0ffbf000 r-xp 00000000 08:03 4312393   /lib/tls/libc-2.3.3.so
>>> 0ffbf000-0ffc0000 ---p 0014f000 08:03 4312393   /lib/tls/libc-2.3.3.so
>>> 0ffc0000-0ffc2000 r--p 00150000 08:03 4312393   /lib/tls/libc-2.3.3.so
>>> 0ffc2000-0ffc6000 rwxp 00152000 08:03 4312393   /lib/tls/libc-2.3.3.so
>>> 0ffc6000-0ffc8000 rwxp 0ffc6000 00:00 0
>>> 0ffd0000-0ffec000 r-xp 00000000 08:03 4309011   /lib/ld-2.3.3.so
>>> 0fff0000-0fff1000 r--p 00020000 08:03 4309011   /lib/ld-2.3.3.so
>>> 0fff1000-0fff2000 rwxp 00021000 08:03 4309011   /lib/ld-2.3.3.so
>>> 10000000-10004000 r-xp 00000000 08:03 917536    /bin/cat
>>> 10013000-10015000 rwxp 00003000 08:03 917536    /bin/cat
>>> 10015000-10036000 rwxp 10015000 00:00 0         [heap]
>>> f7deb000-f7feb000 r--p 00000000 08:03 2560322 
>>> /usr/lib/locale/locale-archive
>>> f7feb000-f7fec000 rw-p f7feb000 00:00 0
>>> ffe6d000-ffe82000 rw-p ffffffeb000 00:00 0      [stack]

> Chris isn't the first to be concerned by that: there's a patch in
> -mm which just shows 0 instead of anon vm_pgoff in /proc/<pid>/maps
> output.  That patch is on akpm's list for 2.6.30 merge, but I think
> hasn't gone to Linus yet: expect it in a later batch.

Alternately, what about just making the offset for the stack match the 
starting address of the VMA?  That way it would look the same as other 
anonymous areas, and as a bonus would look the same as previous 
releases.  Arguably, /proc/<pid>/maps should count as userspace-visible API.

Chris

