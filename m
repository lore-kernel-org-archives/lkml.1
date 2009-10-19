Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZJSO7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZJSO7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZJSO7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:59:44 -0400
Received: from aglcosbs01.cos.agilent.com ([192.25.218.35]:46093 "EHLO
	aglcosbs01.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbZJSO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:59:44 -0400
Message-ID: <4ADC7EDD.9030307@agilent.com>
Date: Mon, 19 Oct 2009 07:59:41 -0700
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Using remap_pfn_range() to increase total_vm beyond RLIMIT_AS
References: <4AD7916A.2080200@agilent.com> <4ADBCCFA.1020507@goop.org>
In-Reply-To: <4ADBCCFA.1020507@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 14:59:46.0103 (UTC) FILETIME=[CC161470:01CA50CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>> I think this means that a device driver can map pages into
>> a process and thus effectively increase address space of
>> a process above and beyond the limit set by RLIMIT_AS.
> 
> I suspect this is justified because remap_pfn_range is generally
> (always?) used to map device memory, and other memory which isn't
> represented by struct pages, so it doesn't really count as real memory
> usage.

Well, perhaps not always.

http://lkml.org/lkml/2008/12/3/453

http://www.scs.ch/~frey/linux/memorymap.html


While DMA related activity is the most obvious reason a driver
might want to allocate memory and inject it into userspace,
I could imagine other reasons (though not necessarily good ones)
where it is more efficient to simply copy data to/from a buffer
shared with a driver.

In both the scenarios outlined, this would be real memory
and not simply IO space.


As to whether it's even justified for IO space, I'm uncertain.

The reference material at www.opengroup.org is not crystal clear:

http://www.opengroup.org/onlinepubs/009695399/functions/getrlimit.html

> RLIMIT_AS
> This is the maximum size of a process' total available memory, in
> bytes. If this limit is exceeded, the malloc() and mmap() functions
> shall fail with errno set to [ENOMEM]. In addition, the automatic stack
> growth fails with the effects outlined above.


I think controlling the size of the address space of the process
is the intent (likely evidenced by the name RLIMIT_AS), but the
text only speaks of user space APIs malloc() and mmap(). The
text does hint that this should apply to other indirect
means of address space expansion by describing stack growth.

One could also regard memory injected by device drivers as mmap()
by other means.

Earl



