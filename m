Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYFYVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYFYVWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFYVWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:22:39 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44305 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbYFYVWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:22:38 -0400
Message-ID: <4862B72D.7060103@linux.vnet.ibm.com>
Date: Wed, 25 Jun 2008 16:22:53 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] hugetlb reservations -- MAP_PRIVATE fixes for split vmas
 V2
References: <485A8903.9030808@linux.vnet.ibm.com> <1214242533-12104-1-git-send-email-apw@shadowen.org>
In-Reply-To: <1214242533-12104-1-git-send-email-apw@shadowen.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> As reported by Adam Litke and Jon Tollefson one of the libhugetlbfs
> regression tests triggers a negative overall reservation count.  When
> this occurs where there is no dynamic pool enabled tests will fail.
>
> Following this email are two patches to address this issue:
>
> hugetlb reservations: move region tracking earlier -- simply moves the
>   region tracking code earlier so we do not have to supply prototypes, and
>
> hugetlb reservations: fix hugetlb MAP_PRIVATE reservations across vma
>   splits -- which moves us to tracking the consumed reservation so that
>   we can correctly calculate the remaining reservations at vma close time.
>
> This stack is against the top of v2.6.25-rc6-mm3, should this solution
> prove acceptable it would need slipping underneath Nick's multiple hugepage
> size patches and those updated.  I have a modified stack prepared for that.
>
> This version incorporates Mel's feedback (both cosmetic, and an allocation
> under spinlock issue) and has an improved layout.
>
> Changes in V2:
>  - commentry updates
>  - pull allocations out from under hugetlb_lock
>  - refactor to match shared code layout
>  - reinstate BUG_ON's
>
> Jon could you have a test on this and see if it works out for you.
>
> -apw
>   
Version two works for me too.  I am not seeing the reserve value become
negative when running the libhuge tests.

Jon

