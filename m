Return-Path: <linux-kernel-owner+w=401wt.eu-S2993052AbXDTRTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993052AbXDTRTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993291AbXDTRTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:19:07 -0400
Received: from holomorphy.com ([66.93.40.71]:42201 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993052AbXDTRTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:19:04 -0400
Date: Fri, 20 Apr 2007 10:19:28 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
Message-ID: <20070420171928.GA2986@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com> <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com> <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com> <20070420171118.GZ2986@holomorphy.com> <Pine.LNX.4.64.0704201012500.20723@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704201012500.20723@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, William Lee Irwin III wrote:
>> The core VM can do that but the hugetlb architectural code can't fall
>> back to smaller page sizes. It also should not be put into a situation
>> where it needs to do so given the semantics it must honor.

On Fri, Apr 20, 2007 at 10:15:00AM -0700, Christoph Lameter wrote:
> Wel we could potentially add a handle_pmd_fault to the vm...?

Unconscionably foul. I guess x86-uber-alles pagetables in the core vm
is the Linux way, though.


On Fri, 20 Apr 2007, William Lee Irwin III wrote:
>> Also, the final assertion is inaccurate. Fault handlers must instantiate
>> pages of order mapping->order when faulting in a page of a file with
>> a given pagecache size. The semantics of faulting and mmap()'ing are

On Fri, Apr 20, 2007 at 10:15:00AM -0700, Christoph Lameter wrote:
> Why? I agree that the page state of the higher order page must be updated 
> consistently but one can use a pte to map a 4k chunk of a higher 
> order page.

Probably just terminological disagreement here. I was referring to
allocating the higher-order page from the fault path here, not mapping
it or a piece of it with a user pte.


-- wli
