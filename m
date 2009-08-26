Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbZHZQ0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbZHZQ0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:26:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZHZQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:26:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:60119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZHZQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:26:08 -0400
Message-ID: <4A95602A.5040109@vflare.org>
Date: Wed, 26 Aug 2009 21:47:46 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
References: <200908241007.47910.ngupta@vflare.org> <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com> <4A92EBB4.1070101@vflare.org> <Pine.LNX.4.64.0908242132320.8144@sister.anvils> <4A930313.9070404@vflare.org> <Pine.LNX.4.64.0908242224530.10534@sister.anvils> <4A93FAA5.5000001@vflare.org> <4A94358C.6060708@vflare.org> <alpine.DEB.1.10.0908261209240.9933@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0908261209240.9933@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2009 09:40 PM, Christoph Lameter wrote:
> On Wed, 26 Aug 2009, Nitin Gupta wrote:
>
>> I went crazy. I meant 40 bits for PFN -- not 48. This 40-bit PFN should be
>> sufficient for all archs. For archs where 40 + PAGE_SHIFT<  MAX_PHYSMEM_BITS
>> ramzswap will just issue a compiler error.
>
> How about restricting the xvmalloc memory allocator to 32 bit? If I
> understand correctly xvmalloc main use in on 32 bit in order to be
> able to use HIGHMEM?
>
>

I have just replaced all PFN usage with struct page in xvmalloc.

The main use of xvmalloc is not just the use of HIGHMEM -- its just one
of the things. Other reasons are:
  - O(1) alloc/free
  - Low fragmentation
  - Allocates 0-order pages to expand pools

Following gives more information:
http://code.google.com/p/compcache/wiki/xvMalloc
http://code.google.com/p/compcache/wiki/xvMallocPerformance

Thanks,
Nitin
