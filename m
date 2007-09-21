Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbXIUSuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbXIUSuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbXIUSuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:50:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36796 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760110AbXIUSuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:50:03 -0400
Date: Fri, 21 Sep 2007 11:50:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, tony.luck@intel.com,
       asit.k.mallick@intel.com
Subject: Re: x86_64: potential critical issue with quicklists and page table
 pages
In-Reply-To: <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709211149040.17160@schroedinger.engr.sgi.com>
References: <20070921180742.GH20863@linux-os.sc.intel.com>
 <alpine.LFD.0.999.0709211139550.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007, Linus Torvalds wrote:

> > Can we revert this commit for 2.6.23 and look at this code post 2.6.23?
> 
> I'll happily revert it, but I want to understand this better, so more of 
> an explanation of the codepath that actually does something wrong, please.

The quicklists collect pages while we gather pages for TLB flushing. 
These pages must be kept until the actual TLB flush has occurred. The 
optimization of releasing off node pages early is therefore not valid.

