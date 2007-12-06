Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbXLFJzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbXLFJzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXLFJzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:55:11 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43096 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751095AbXLFJzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:55:10 -0500
Date: Thu, 6 Dec 2007 10:55:07 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
cc: Geoff Levand <geoffrey.levand@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
In-Reply-To: <20071206142552.694B.Y-GOTO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.62.0712061052390.6524@pademelon.sonytel.be>
References: <20071205151147.9db4640b.akpm@linux-foundation.org>
 <47573806.8000808@am.sony.com> <20071206142552.694B.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-158887142-1196934907=:6524"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-158887142-1196934907=:6524
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 6 Dec 2007, Yasunori Goto wrote:
> > I'll try Milton's suggestion to pre-allocate the memory early.  It seems
> > that should work as long as nothing else before the hot-plug mem is added
> > needs a large chunk.
> 
> Hello. Geoff-san. Sorry for late response.
> 
> Could you tell me the value of the following page_size calculation
> in vmemmap_populate()? I think this page_size may be too big value. 
> 
> ------
> int __meminit vmemmap_populate(struct page *start_page,
>                                        unsigned long nr_pages, int node)
>                            :
>                            :
>         unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
>                            :
> -------

24 MiB

> In addition, I remember that current add_memory() is designed for
> only 1 section's addition. (See: memory_probe_store() and
> sparse_mem_map_populate().
> they require only for 1 section's mem_map by specifing
> PAGES_PER_SECTION.)
> The 1 section size for normal powerpc box is only 16MB.
> (IA64 -> 1GB, x86-64 -> 128MB).
> 
> But, if my understanding is correct, PS3's add_memory() requires all
> of total memory. I'm afraid something other problems might be hidden
> in this issue yet.
> 
> (However, I think Milton-san's suggestion is very desirable. 
>  If preallocation of hotadd works on ia64 too, I'm very glad.)

PS3 initially starts with 128 MiB.
Later hotplug is used to add the remaining memory (96 or 112 MIB, IIRC).

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-158887142-1196934907=:6524--
