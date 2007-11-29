Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXK2Aef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXK2Aef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbXK2Ae1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:34:27 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49365 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbXK2Ae0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:34:26 -0500
Date: Wed, 28 Nov 2007 18:33:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: How to map user space's virtual memory into kernel logical address
  space
In-reply-to: <25b1e0c5-c6f4-43e6-a168-7cb701ef9018@e10g2000prf.googlegroups.com>
To: Maitre Bart <maitrebart@excite.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <474E08F3.6020508@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <25b1e0c5-c6f4-43e6-a168-7cb701ef9018@e10g2000prf.googlegroups.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maitre Bart wrote:
> A given app is allocating a large amount of memory (~10M) with
> malloc().
> It passes this pointer to the kernel (device driver) via an custom
> ioctl.
> I would like the driver to work on that memory with a pointer (as if
> it was allocated with vmalloc) as well as the user space too (upon
> return of the syscall).
> Is there a way to map a user space's virtual memory range into the
> kernel logical address space?
> 
> As far as I learned from my readings, using the user-space pointer
> directly in kernel space will not work.
> 
> Of course, copy_from_user() is out of question for efficiency
> purposes.
> 
> ioremap() is pretty close to what I wish to do except that it accepts
> a physical address and I don't how to get it from a user space
> pointer. And since a physical address is required, I assume the range
> is considered contiguous, which is not really the case for malloc().
> 
> mmap()/remap_pfn_range() are interesting but I don't know how to get a
> kernel pointer out of them.
> 
> kmap() does the job for a single page (and anyway, I wouldn't know how
> to  feed it with a struct page from the userland pointer).
> 
> get_user_pages() looks promising but it seems I have to call kmap() on
> each page, so it looks like I cannot operate on the buffer with a
> single pointer.
> 
> Does any one know if it is possible? And if so, how can I do it?

10MB is an awfully big mapping to put into kernel virtual memory space. 
I suspect it might be easier to allocate the memory in the kernel and 
map it in from userspace, but then you have the same problem (and 10MB 
is awfully big for vmalloc).

Is there a good reason why you have to be able to do this? There's 
likely a better way.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

