Return-Path: <linux-kernel-owner+w=401wt.eu-S932502AbXCDBXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbXCDBXX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 20:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbXCDBXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 20:23:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932502AbXCDBXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 20:23:22 -0500
Message-ID: <45EA1F7B.9060107@redhat.com>
Date: Sat, 03 Mar 2007 20:23:07 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: userspace pagecache management tool
References: <20070303122935.f1ab0067.akpm@linux-foundation.org>	<45E9DD4A.2060806@redhat.com>	<20070303131204.6706a95c.akpm@linux-foundation.org>	<45E9E910.2070804@redhat.com>	<20070303140744.b22699dd.akpm@linux-foundation.org>	<45E9F5DA.2070708@redhat.com>	<20070303145221.2a42cc0f.akpm@linux-foundation.org>	<45EA0C3D.1010001@redhat.com> <20070303170237.31d26382.akpm@linux-foundation.org>
In-Reply-To: <20070303170237.31d26382.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 03 Mar 2007 19:01:01 -0500 Rik van Riel <riel@redhat.com> wrote:

>> The use-once policy we have in the kernel should work
>> perfectly fine for backups.  All we need to do is
>> actually honor the accessed bit on active page cache
>> pages, instead of flushing them onto the inactive
>> list.
>>
>> What am I overlooking?
> 
> That'll improve backups but will break other things.
> 
> To do this effectively we'd need to change the policy so that new pagecache
> allocations cause no scanning of used-twice pages at all.  So that even
> after many gigs of backing up, the working set is still there.
> 
> Problem is, (for example) what about the person who has 80% of memory in
> used-twice state and who then reads a file or files which are 20% or more of
> the size of memory, two or more times.  It'll be 100% cache misses, every time.
> This will happen quite a lot.  IOW, once those pages are in used-twice state,
> how does further pagecache activity ever get them _out_ of that state?  Only
> by joining the used-twice page set, and that can't happen if the used-once-so-far
> pages got reclaimed.
> 
> Doing a refault thing would help a bit, but stops working at a certain point.

At what point does it stop working?

I am not asking this to be difficult, I just want to get Linux
a VM that does not need to be kludged up every time a distro
ships it to its customers.

I believe one starting point would be a concept that people
cannot shoot holes in any more.  That is no guarantee, but
as long as the concept has known holes coding it up is likely
to be a waste of time since the code will need kludges to
deal with the problems later on and we'd be back to square
one.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
