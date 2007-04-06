Return-Path: <linux-kernel-owner+w=401wt.eu-S1767504AbXDFC23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767504AbXDFC23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 22:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767509AbXDFC22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 22:28:28 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:27766 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767504AbXDFC21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 22:28:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=oAlABQixeoN+syrQaMKdzE+DIVqyOMFtb2ZpOIkrXXyI7J7i7717W4/ZX6xox9hQdenmGBz4FdznMurnz5jsIb0e48VpR8ncEhTD+y8g1MrVn8VhfLagSHvikN1hHTKJ3+SZVqXPIu4IroNb6By0ViwMyMKXiCQ2lbpznUySRGw=  ;
X-YMail-OSG: 2sUF4CwVM1kBJus0DMy5JeQ8na_ZqtbhwhKU31zPTjqSPvzORDhOo5q2qtE88rv5EIPiB4a8GYB6sgW3efBJ53xFi1VohMOoW1AeUWe6pTy_Z8EvHDsg0c8P77Ydjw--
Message-ID: <4615B043.8060001@yahoo.com.au>
Date: Fri, 06 Apr 2007 12:28:19 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <4614A5CC.5080508@redhat.com> <46151F73.50602@redhat.com>
In-Reply-To: <46151F73.50602@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> In case somebody wants to play around with Rik patch or another
> madvise-based patch, I have x86-64 glibc binaries which can use it:
> 
>   http://people.redhat.com/drepper/rpms
> 
> These are based on the latest Fedora rawhide version.  They should work
> on older systems, too, but you screw up your updates.  Use them only if
> you know what you do.
> 
> By default madvise(MADV_DONTNEED) is used.  With the environment variable

Cool. According to my thinking, madvise(MADV_DONTNEED) even in today's
kernels using down_write(mmap_sem) for MADV_DONTNEED is better than
mmap/mprotect, which have more fundamental locking requirements, more
overhead and no benefits (except debugging, I suppose).

MADV_DONTNEED is twice as fast in single threaded performance, and an
order of magnitude faster for multiple threads, when MADV_DONTNEED only
takes mmap_sem for read.

Do you plan to include this change in general glibc releases? Maybe it
will make google malloc obsolete? ;) (I don't suppose you'd be able to
get any tests done, Andrew?)

-- 
SUSE Labs, Novell Inc.
