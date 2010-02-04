Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab0BDInA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:43:00 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:42595 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab0BDIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=F931bHDXvu2uSKFBArsVtqsOx0gtBWcrr9kF776jFwQnRHR7dekgkiZ2rwuZET4Ty3
         VsV99/lDa1O0+sGxe0BOFD6tbbh5c+jx9oxKijrUd8DHym4C5UwpXQ3Uc0M1Y5nJkpjC
         i6abp7CMWeIPynF20guiu9Gxt+CzEKO8fj7HU=
Message-ID: <4B6A8889.4070407@gmail.com>
Date: Thu, 04 Feb 2010 10:42:49 +0200
From: Oleg Kutkov <elenbert@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Problem with set_memory_rw
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


"KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com 
<mailto:kamezawa.hiroyu@jp.fujitsu.com>> wrote:
> set_memory_rw()'s 1st argument requires virtual address.
> So, you need virtual address of the page you want.
>
>  - phys_to_virt() ... convert physical address to virtual address.
>  - virt_to_phys() ... convert virtual address to physical.
>
> Anyway, RW is vitual address mapping's attribute and not for physical.
>
> Thanks,
> -Kame   
>

Thank for answer!
But this is a very strange, because 0x0509940, i passed, - it a virtual 
memory address (i got it from System.map, this is a system call table, 
on my machine). set_memory_rw return zero, anyway. So i can't continue 
writing to memory. Maybe, system call table is much write protected, so 
i can't change attribute of memory page?
One more interesting thing:

struct page *pg;
pg = virt_to_page(addr);
unsigned long page_addr;
page_addr = (unsigned long) page_address(pg);


addr - this is my virtual address (provided by System.map)
But page_addr got another value!
What wrong?
Sorry, if my questions is to stupid.

P.S. I know, that overwriting system call table is very bad, i just 
experimenting with my own network drivers and i need to replace some 
network system calls..


Best regard,
Oleg.

