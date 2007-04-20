Return-Path: <linux-kernel-owner+w=401wt.eu-S2993290AbXDTRPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993290AbXDTRPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993285AbXDTRPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:15:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36201 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993290AbXDTRPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:15:01 -0400
Date: Fri, 20 Apr 2007 10:15:00 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
In-Reply-To: <20070420171118.GZ2986@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704201012500.20723@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com>
 <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com>
 <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com>
 <20070420171118.GZ2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, William Lee Irwin III wrote:
> 
> On Fri, Apr 20, 2007 at 09:30:30AM -0700, Christoph Lameter wrote:
> > We can map arbitrary 4k chunks of larger pages.
> 
> The core VM can do that but the hugetlb architectural code can't fall
> back to smaller page sizes. It also should not be put into a situation
> where it needs to do so given the semantics it must honor.

Wel we could potentially add a handle_pmd_fault to the vm...?
 
> Also, the final assertion is inaccurate. Fault handlers must instantiate
> pages of order mapping->order when faulting in a page of a file with
> a given pagecache size. The semantics of faulting and mmap()'ing are

Why? I agree that the page state of the higher order page must be updated 
consistently but one can use a pte to map a 4k chunk of a higher 
order page.


