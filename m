Return-Path: <linux-kernel-owner+w=401wt.eu-S2993055AbXDTRKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993055AbXDTRKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993021AbXDTRKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:10:55 -0400
Received: from holomorphy.com ([66.93.40.71]:40741 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993055AbXDTRKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:10:54 -0400
Date: Fri, 20 Apr 2007 10:11:18 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
Message-ID: <20070420171118.GZ2986@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com> <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com> <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, William Lee Irwin III wrote:
>> Careful there. mmap() needs more than this.
>> (1) mapping->order is variable within an fs, so the architectural code
>> 	would need some vague awareness of the underlying page size
>> 	being variable unless the fs restricts it properly.

On Fri, Apr 20, 2007 at 09:30:30AM -0700, Christoph Lameter wrote:
> We can map arbitrary 4k chunks of larger pages.

The core VM can do that but the hugetlb architectural code can't fall
back to smaller page sizes. It also should not be put into a situation
where it needs to do so given the semantics it must honor.


On Fri, 20 Apr 2007, William Lee Irwin III wrote:
>> The hugetlbfs fs stub has by and large been a huge embarrassment to me,
>> so I'd welcome the opportunity to foist off the vfs lifting onto ramfs.
>> I'd be happier with real superpages, but it's not my kernel.

On Fri, Apr 20, 2007 at 09:30:30AM -0700, Christoph Lameter wrote:
> We are not doing superpages in any form. The filesystem determines it page 
> cache size thereby managing pages of arbitrary order. The usual VM 
> mmap will work using PAGE_SIZEd mappings as now (once that is working 
> right). There is no need to tie the page cache order to the page sizes 
> used by mmap or the sizes used by the fault handling of the VM.

Fine, s/real superpages/superpages/ -- I'm not picky enough.

Also, the final assertion is inaccurate. Fault handlers must instantiate
pages of order mapping->order when faulting in a page of a file with
a given pagecache size. The semantics of faulting and mmap()'ing are
slightly underspecified but no requirements for the size of the newly
established translations are included, so they can be PAGE_SIZE easily
enough.


-- wli
