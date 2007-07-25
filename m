Return-Path: <linux-kernel-owner+w=401wt.eu-S1764800AbXGYNZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764800AbXGYNZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 09:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbXGYNZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 09:25:11 -0400
Received: from il.qumranet.com ([82.166.9.18]:38611 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXGYNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 09:25:10 -0400
Message-ID: <46A74F34.5040508@qumranet.com>
Date: Wed, 25 Jul 2007 16:25:08 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Shaohua Li <shaoh.li@gmail.com>
CC: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] [RFC 7/8]KVM: swap out guest pages
References: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>	 <46A612C8.6090804@qumranet.com>	 <288dbef70707250455p656b09cft20ebc7a013e8a76f@mail.gmail.com> <288dbef70707250620u5483d5dbxbcc461f8f685acdc@mail.gmail.com>
In-Reply-To: <288dbef70707250620u5483d5dbxbcc461f8f685acdc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 25 Jul 2007 16:25:08 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote:
>> So write to a file, right? Yes, it can avoid use move to swap, and
>> should be feasible.
> Say you want to write guest pages out to file A of back store fs, in
> kvm->writepage(), we could do:
> 1. lower_page = grap_cache_page(file A's mapping)
> 2. file A's ->prepare_write(lower_page)
> 3. copy kvm guest page to lower_page
> 4. file A's ->commit_write(lower_page)
> then guest page can be freed. Just like the stack fs does. The
> downside is step 1 needs allocate a new page.

Yeah.  Hopefully we can find a better solution, the copy isn't pretty
(though it's probably not too bad from a performance point of view
compared to the IPIs involved).

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

