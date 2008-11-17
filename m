Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYKQJP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYKQJP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYKQJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:15:11 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:8814 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYKQJPI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:15:08 -0500
Message-Id: <49214454.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 17 Nov 2008 09:15:48 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ian Campbell" <ian.campbell@citrix.com>, "Ingo Molnar" <mingo@elte.hu>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 03 of 38] swiotlb: allow
	 architectures	tooverrideswiotlb pool allocation
References: <patchbomb.1226603398@abulafia.goop.org>
 <e9f25b3bb6625ee88f9f.1226603401@abulafia.goop.org>
 <491D4C89.76E4.0078.0@novell.com> <491DD27A.30707@goop.org>
In-Reply-To: <491DD27A.30707@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 14.11.08 20:33 >>>
>Jan Beulich wrote:
>> Not directly related to this patch alone, but to the combined set of changes
>> to swiotlb: I don't see any handling of CONFIG_HIGHMEM here (or at least
>> a note that this a known limitation needing work). I mention this because
>> this was the largest part of the changes I had posted long ago to make
>> lib/swiotlb.c Xen-ready, and which got rejected due to their ugliness.
>>   
>
>Was that Andi's objection on the grounds that he didn't think that Xen 
>should need swiotlb at all?

No, Tony Luck actually merged it, but someone else (I don't recall who it
was) requested it to be reverted again.

>I have to admit I didn't follow that thread very closely (or threads, as 
>I seem to remember).  Do you have a pointer to the pertinent bits?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=51099005ab8e09d68a13fea8d55bc739c1040ca6

>> While perhaps less intrusive to take care of, I also didn't see an equivalent
>> of the range_straddles_page_boundary() logic, without which I can't see
>> how this would work in the common case.
>>   
>Could you be more specific?  The swiotlb allocation should be machine 
>contiguous and so there's no stradding required, but I think I'm missing 
>your point.

The question is whether a multi-page piece of memory must be funneled
through the swiotlb in the first place. In native code, checking whether
the first/last byte satisfies the address_needs_mapping() check is
sufficient, but in Xen you also need to check whether the known to be
physically contiguous pages are also machine-contiguous.

Jan

