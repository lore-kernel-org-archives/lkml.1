Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZCRQIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZCRQIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 12:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbZCRQI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 12:08:26 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:45613 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbZCRQIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 12:08:25 -0400
Message-ID: <49C11C47.8040908@vflare.org>
Date: Wed, 18 Mar 2009 21:37:35 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3]: xvmalloc memory allocator
References: <49BF8ABC.6040805@vflare.org> <49BF8B8B.40408@vflare.org>	 <alpine.DEB.1.10.0903171237180.21582@qirst.com>	 <d760cf2d0903171028o600dc94cn7a5238520d104455@mail.gmail.com>	 <alpine.DEB.1.10.0903171355410.26058@qirst.com> <84144f020903171134q2283d01aq21a2faaa77ab07c6@mail.gmail.com>
In-Reply-To: <84144f020903171134q2283d01aq21a2faaa77ab07c6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090317-0, 17-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, 17 Mar 2009, Nitin Gupta wrote:
>>> Creating slabs for sizes in range, say, [32, 3/4*PAGE_SIZE] separated by
>>> 64bytes
>>> will require 48 slabs! Then for slab of each size class will have wastage
>>> due to
>>> unused slab objects in each class.
>>> Larger difference in slab sizes (and thus small no. of them), will surely
>>> cause too much
>>> wastage due to internal fragmentation.
> 
> On Tue, Mar 17, 2009 at 10:58 AM, Christoph Lameter
> <cl@linux-foundation.org> wrote:
>> The slabs that match existing other slabs of similar sizes will be aliased
>> and not created. Create the 48 slabs and you likely will only use 10 real
>> additional ones. The rest will just be pointing to existing ones.
> 
> Yup. One thing I don't quite understand is why you need all the 48
> caches in the first place. Allocation sizes tend to be clustered and I
> would have imagined you'd see that when compressing page sized chunks
> as well.

Compressed page lengths sometimes do tend to cluster within somewhat
small range. However, the range of where majority of pages will lie depends
highly of workload - sometimes range is not clear and sometime there is no
preferred range at all. Please refer this data:
http://code.google.com/p/compcache/wiki/CompressedLengthDistribution

It shows compressed page size distribution for various workloads.

> Using kmemtrace to analyze the exact reason for the bad
> fragmentation would probably be helpful.
> 

That was purely internal fragmentation.
Wastage per obj = ksize(obj) - actual_size.

Code used for testing:
http://code.google.com/p/compcache/source/browse/trunk/sub-projects/testing/kmalloc_test/kmalloc_test.c
This is a "SwapReplay client". Please see:
http://code.google.com/p/compcache/wiki/SwapReplayDesign

Thanks,
Nitin




