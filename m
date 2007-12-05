Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbXLEXp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbXLEXp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLEXpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:45:18 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:54047 "EHLO
	mail67-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXLEXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:45:16 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <47573806.8000808@am.sony.com>
Date: Wed, 05 Dec 2007 15:45:10 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <47537F2E.2070204@am.sony.com>	<b91f94dd5b35247fecf52090c0b3890f@bga.com>	<Pine.LNX.4.62.0712051013040.28855@pademelon.sonytel.be> <20071205151147.9db4640b.akpm@linux-foundation.org>
In-Reply-To: <20071205151147.9db4640b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Dec 2007 23:45:10.0744 (UTC) FILETIME=[DFAF8D80:01C83798]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 5 Dec 2007 10:52:48 +0100 (CET)
> Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
>> --------------------------------------------------------------------------------
>> Subject: sparsemem: sparse_add_one_section() may fail to allocate memory
>> 
>> sparsemem: sparse_add_one_section() may fail to allocate memory, and must check
>> whether the allocation succeeded before proceeding to touch the allocated
>> memory.
>> 
>> From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> 
>> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
>> ---
>> FIXME There are still some possible memory leaks in sparse_add_one_section():
>>   - usemap is never deallocated
>>   - __kfree_section_memmap() is a not yet implemented dummy
> 
> I already had
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-improve-the-error-handling-for-sparse_add_one_section.patch
> and
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/broken-out/mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
> 
> queued.  Do they fix the problem, and should they be merged in 2.6.24?

No, a quick test shows it just panics in a different place.  Geert's
patch does also.

I'll try Milton's suggestion to pre-allocate the memory early.  It seems
that should work as long as nothing else before the hot-plug mem is added
needs a large chunk.

-Geoff

