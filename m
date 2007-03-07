Return-Path: <linux-kernel-owner+w=401wt.eu-S2992750AbXCGXoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992750AbXCGXoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:44:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992760AbXCGXoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:44:12 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:47005 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992750AbXCGXoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:44:09 -0500
Date: Wed, 7 Mar 2007 15:40:48 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bill Irwin <bill.irwin@oracle.com>, Adam Litke <agl@us.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix get_unmapped_area and fsync for hugetlb shm segments
Message-ID: <20070307234048.GR18774@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adam Litke <agl@us.ibm.com>, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070301234608.29532.66932.stgit@localhost.localdomain> <20070302002818.GF10643@holomorphy.com> <m1hcswbqru.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcswbqru.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Irwin <bill.irwin@oracle.com> writes:
>> A comment to prepare others for the impending doubletake might be nice.
>> Or maybe just open-coding the equality check for &hugetlbfs_file_operations
>> in is_file_shm_hugepages() if others find it as jarring as I. Please
>> extend my ack to any follow-up fiddling with that.

On Wed, Mar 07, 2007 at 04:03:17PM -0700, Eric W. Biederman wrote:
> You did notice we are testing a different struct file?

Yes.


Bill Irwin <bill.irwin@oracle.com> writes:
>> The patch addresses relatively straightforward issues and naturally at
>> that.

On Wed, Mar 07, 2007 at 04:03:17PM -0700, Eric W. Biederman wrote:
> The whole concept is recursive so I'm not certain being a recursive check
> is that bad but I understand the point.

Hence my characterization as natural. You did notice this was an ack?


On Wed, Mar 07, 2007 at 04:03:17PM -0700, Eric W. Biederman wrote:
> I think the right answer is most likely to add an extra file method or
> two so we can remove the need for is_file_hugepages.
> There are still 4 calls to is_file_hugepages in ipc/shm.c and
> 2 calls in mm/mmap.c not counting the one in is_file_shm_hugepages.
> The special cases make it difficult to properly wrap hugetlbfs files
> with another file, which is why we have the weird special case above.

It's not clear to me that the core can be insulated from hugetlb's
distinct pagecache and memory mapping granularities in a Linux-native
manner, but if you come up with something new or manage to get the
known methods past Linus, akpm, et al, more power to you.

I'm not entirely sure what you're up to, but I'm mostly here to sanction
others' design notions since my own are far too extreme, and, of course,
review and ack patches, take bugreports and write fixes (not that I've
managed to get to any of them first in a long while, if ever), and so on.
I say killing the is_whatever_hugepages() checks with whatever abstraction
is good, since I don't like them myself, provided it's sane. Go for it.


-- wli
