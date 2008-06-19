Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbYFSRTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbYFSRTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYFSRT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:19:29 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2892 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYFSRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:19:28 -0400
Date: Thu, 19 Jun 2008 18:16:44 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Jon Tollefson <kniht@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: Re: 2.6.26-rc5-mm3: BUG large value for HugePages_Rsvd
Message-ID: <20080619171644.GC13275@shadowen.org>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <485A8903.9030808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485A8903.9030808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 11:27:47AM -0500, Jon Tollefson wrote:
> After running some of the libhugetlbfs tests the value for
> /proc/meminfo/HugePages_Rsvd becomes really large.  It looks like it has
> wrapped backwards from zero.
> Below is the sequence I used to run one of the tests that causes this;
> the tests passes for what it is intended to test but leaves a large
> value for reserved pages and that seemed strange to me.
> test run on ppc64 with 16M huge pages

Yes Adam reported that here yesterday, he found it in his hugetlfs testing.
I have done some investigation on it and it is being triggered by a bug in
the private reservation tracking patches.  It is triggered by the hugetlb
test which causes some complex vma splits to occur on a private mapping.

I believe I have the underlying problem nailed and do have some nearly
complete patches for this and they should be in a postable state by
tommorrow.

-apw
