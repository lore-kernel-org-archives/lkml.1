Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYEFFfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYEFFfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbYEFFfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:35:41 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59890 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYEFFfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:35:40 -0400
Message-ID: <481FEDEF.9030901@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 11:04:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, skumar@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       rientjes@google.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 3/4] Add rlimit controller accounting and control
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain> <20080503213814.3140.66080.sendpatchset@localhost.localdomain> <20080505152451.6dceec74.akpm@linux-foundation.org>
In-Reply-To: <20080505152451.6dceec74.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 04 May 2008 03:08:14 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> +	if (res_counter_charge(&rcg->as_res, (mm->total_vm << PAGE_SHIFT)))
> 
> I worry a bit about all the conversion between page-counts and byte-counts
> in this code.
> 
> For example, what happens if a process sits there increasing its rss with
> sbrk(4095) or sbrk(4097) or all sorts of other scenarios?  Do we get in a
> situation in which the accounting is systematically wrong?
> 

We already do all our accounting in pages for total_vm (field of mm_struct).
task_vsize() for example multiplies PAGE_SIZE with total_vm before returning the
result.

> Worse, do we risk getting into that situation in the future, as unrelated
> changes are made to the surrounding code?
> 

I can't see that happening, but I'll look again and request reviewers to help me
identify any such problems that can occur.

> IOW, have we chosen the best, most maintainable representation for these
> things?
> 

That's a good question. From the sustenance point of view, resource counters
have worked really well so far. Abstracting accounting and tracking from the
controllers has been a good thing. One of the goals of the rlimit controller is
to keep it open for extension, so that others can add their own control for
other resources like mlock'ed pages.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
