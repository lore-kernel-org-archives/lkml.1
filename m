Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbXLHCuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbXLHCuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 21:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751638AbXLHCuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 21:50:00 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:20106 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbXLHCt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 21:49:59 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <475A05A8.2050909@am.sony.com>
Date: Fri, 07 Dec 2007 18:47:04 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Andrew Morton <akpm@linux-foundation.org>, miltonm@bga.com,
       clameter@sgi.com, apw@shadowen.org, linux-kernel@vger.kernel.org
Subject: Re: PS3: trouble with SPARSEMEM_VMEMMAP and kexec
References: <Pine.LNX.4.62.0712061052390.6524@pademelon.sonytel.be> <Pine.LNX.4.62.0712061055140.6524@pademelon.sonytel.be> <20071206191717.6955.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20071206191717.6955.Y-GOTO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2007 02:47:07.0390 (UTC) FILETIME=[9F5709E0:01C83944]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
>> On Thu, 6 Dec 2007, Geert Uytterhoeven wrote:
>> > On Thu, 6 Dec 2007, Yasunori Goto wrote:
>> > > > I'll try Milton's suggestion to pre-allocate the memory early.  It seems
>> > > > that should work as long as nothing else before the hot-plug mem is added
>> > > > needs a large chunk.
>> > > 
>> > > Hello. Geoff-san. Sorry for late response.
>> > > 
>> > > Could you tell me the value of the following page_size calculation
>> > > in vmemmap_populate()? I think this page_size may be too big value. 
>> > > 
>> > > ------
>> > > int __meminit vmemmap_populate(struct page *start_page,
>> > >                                        unsigned long nr_pages, int node)
>> > >                            :
>> > >                            :
>> > >         unsigned long page_size = 1 << mmu_psize_defs[mmu_linear_psize].shift;
>> > >                            :
>> > > -------
>> 
>> 16 MiB of course.
> 
> 16 MiB is not page size. It is "section size". 
> IIRC, powerpc's page size must be 4K (or 64K).
> If page size is 4k, vmemmap_alloc_block will call the order 12 page.


By default PS3 uses 4K virtual pages, and 16M linear pages.


> Is it really correct value for vmemmap population?


It seems vmemmap needs linear pages, so I think it is ok.


>> PS3 initially starts with 128 MiB.
>> Later hotplug is used to add the remaining memory (96 or 112 MIB, IIRC).
> 
> Ok.
> Then, add_memory() must be called 6 or 7 times for each sections.


Yes, I call add_memory() once, then it in turn calls sparse_add_one_section()
7 times.

-Geoff


