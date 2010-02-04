Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0BDIKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:10:05 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:54823 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0BDIJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:09:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=PRAZquWx4rjvJ+QcBw1YASZPyVPJEuFraBiS/jl3rN9BnoOBY8Cd9t53DUoxIEXQ0W
         zkvCvvDM7+hktyk1WWPGkh4+1Ye0NnMROIiBpBlqMItNf3LTPoJcuqnpRpPQfWkSusjX
         1pi3MxMiIFDxffMCCPcXGOx6Sg/HZhzfHQTpk=
MIME-Version: 1.0
In-Reply-To: <5e9821061002040006p258c2738y87a26c769c04bcfd@mail.gmail.com>
References: <4B6A5A81.2030207@gmail.com>
	 <20100204144511.b50d3191.kamezawa.hiroyu@jp.fujitsu.com>
	 <5e9821061002040006p258c2738y87a26c769c04bcfd@mail.gmail.com>
Date: Thu, 4 Feb 2010 10:09:57 +0200
Message-ID: <5e9821061002040009t27fc5a81m5075508f3a6634a6@mail.gmail.com>
Subject: Fwd: Problem with set_memory_rw
From: Oleg Kutkov <elenbert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_memory_rw()'s 1st argument requires virtual address.
So, you need virtual address of the page you want.

 - phys_to_virt() ... convert physical address to virtual address.
 - virt_to_phys() ... convert virtual address to physical.

Anyway, RW is vitual address mapping's attribute and not for physical.

Thanks,
-Kame



Thank for answer!
But this is a very strange, because 0x0509940 - it a virtual memory
address (i got it from System.map, this is a system call table, on my
machine). set_memory_rw return zero, anyway. Maybe, system call table
is much write protected, so i can't change attribute of memory page?
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
