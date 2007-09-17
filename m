Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbXIQOJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbXIQOJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 10:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXIQOJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 10:09:41 -0400
Received: from ppsw-8.csi.cam.ac.uk ([131.111.8.138]:50065 "EHLO
	ppsw-8.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbXIQOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:09:40 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
In-Reply-To: <13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk> <1189850897.21778.301.camel@twins> <20070915035228.8b8a7d6d.akpm@linux-foundation.org> <13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <DC408F26-E53F-4F27-9DEF-E996401D95FB@cam.ac.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Date: Mon, 17 Sep 2007 15:09:24 +0100
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Sep 2007, at 15:04, Anton Altaparmakov wrote:
> On 15 Sep 2007, at 11:52, Andrew Morton wrote:
>> On Sat, 15 Sep 2007 12:08:17 +0200 Peter Zijlstra  
>> <peterz@infradead.org> wrote:
>>> Anyway, looks like all of zone_normal is pinned in kernel  
>>> allocations:
>>>
>>>> Sep 13 15:31:25 escabot Normal free:3648kB min:3744kB low:4680kB  
>>>> high: 5616kB active:0kB inactive:3160kB present:894080kB  
>>>> pages_scanned:5336 all_unreclaimable? yes
>>>
>>> Out of the 870 odd mb only 3 is on the lru.
>>>
>>> Would be grand it you could have a look at slabinfo and the like.
>>
>> Definitely.
>>
>>>> Sep 13 15:31:25 escabot free:1090395 slab:198893 mapped:988
>>>> pagetables:129 bounce:0
>>
>> 814,665,728 bytes of slab.
>
> Marc emailed me the contents of /proc/ 
> {slabinfo,meminfo,vmstat,zoneinfo} taken just a few seconds before  
> the machine panic()ed due to running OOM completely...  They files  
> are attached this time rather than inlined so people don't complain  
> about line wrapping!  (No doubt people will not complain about them  
> being attached!  )-:)
>
> If I read it correctly it appears all of low memory is eaten up by  
> buffer_heads.
>
> <quote>
> # name            <active_objs> <num_objs> <objsize> <objperslab>  
> <pagesperslab>
> : tunables <limit> <batchcount> <sharedfactor> : slabdata  
> <active_slabs> <num_s
> labs> <sharedavail>
> buffer_head       12569528 12569535     56   67    1 : tunables   
> 120   60    8 :
> slabdata 187605 187605      0
> </quote>
>
> That is 671MiB of low memory in buffer_heads.

I meant that is 732MiB of low memory in buffer_heads.  (12569535  
num_objs / 67 objperslab * 1 pagesperslab * 4096 PAGE_SIZE)

> But why is the kernel not reclaiming them by getting rid of the  
> page cache pages they are attached to or even leaving the pages  
> around but killing their buffers?
>
> I don't think I am doing anything in NTFS to cause this problem to  
> happen...  Other than using buffer heads for my page cache pages  
> that is but that is hardly a crime!  /-;

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/


