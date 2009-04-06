Return-Path: <linux-kernel-owner+w=401wt.eu-S1759407AbZDFPnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407AbZDFPnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbZDFPhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:37:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:39637 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbZDFPhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:37:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nyg1ZiEarFUeE5cQ2f5NywXUAE4Fi7YKngiHbjrvCDA49E379+el6A8hAJ8qdnnfA/
         YHlP8q/VTYz7QzTynzmSSEAw8mmbtOD8IipgPVtzByslJZU7I3K8T/LUdSmUQege8lVJ
         HuZZTUjku3afQU0GiEubXXJ3fI+iIJNGLbWto=
MIME-Version: 1.0
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4658074803@orsmsx505.amr.corp.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com>
	 <200903302331.10995.a.miskiewicz@gmail.com>
	 <1238449555.4529.1095.camel@localhost.localdomain>
	 <200903310031.10335.a.miskiewicz@gmail.com>
	 <20090331002815.GB10490@linux-os.sc.intel.com>
	 <20090402004933.GE10490@linux-os.sc.intel.com>
	 <5a4c581d0904030253v44294f1bo1c65e89a3db9ae9b@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4658074803@orsmsx505.amr.corp.intel.com>
Date: Mon, 6 Apr 2009 17:37:11 +0200
Message-ID: <5a4c581d0904060837q6315fee6i368038d383dfadd@mail.gmail.com>
Subject: Re: 2.6.29 git master and PAT problems
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 3, 2009 at 3:59 PM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>
>
>>-----Original Message-----
>>From: Alessandro Suardi [mailto:alessandro.suardi@gmail.com]
>>Sent: Friday, April 03, 2009 2:54 AM
>>To: Pallipadi, Venkatesh
>>Cc: Arkadiusz Miskiewicz; Siddha, Suresh B;
>>linux-kernel@vger.kernel.org; Jesse Barnes
>>Subject: Re: 2.6.29 git master and PAT problems
>>
>>On Thu, Apr 2, 2009 at 2:49 AM, Pallipadi, Venkatesh
>><venkatesh.pallipadi@intel.com> wrote:
>>> On Mon, Mar 30, 2009 at 05:28:15PM -0700, Pallipadi, Venkatesh wrote:
>>>> On Mon, Mar 30, 2009 at 03:31:09PM -0700, Arkadiusz
>>Miskiewicz wrote:
>>>> > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
>>>> >
>>>> > More info follows. Now I've switched to
>>>> > e1c502482853f84606928f5a2f2eb6da1993cda1 which contains
>>latest drm fixes and
>>>> > now I get much lower numbers of PAT errors but still.
>>>> >
>>>> > > On Mon, 2009-03-30 at 14:31 -0700, Arkadiusz Miskiewicz wrote:
>>>> > > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
>>>> > > > > Patch here should get rid of these errors.
>>>> > > > >
>>>> > > > > http://marc.info/?l=linux-kernel&m=123788806506230&w=2
>>>> > > > >
>>>> > > > > The patch is in tip and on its way to upstream.
>>>> > > >
>>>> > > > The problem is that kernel I'm running already
>>contains this patch (it's
>>>> > > > merged already). Other ideas?
>>>> > > >
>>>> > > > ratelimiting that error is good IMO anyway.
>>>> > >
>>>> > > Rate limiting will just work around the problem here.
>>Ideally we should
>>>> > > never see these errors. So, it will be better if we can
>>narrow down on
>>>> > > the bug resulting in these error messages.
>>>> >
>>>> > Of course it's better. I'm saying that when these
>>messages "fire" then it's
>>>> > hard to do anything else on the system for a while until
>>these stop.
>>>> >
>>>> > > Can you please send me the output of
>>>> > > # cat /debug/x86/pat_memtype_list
>>>> > > with debugfs mounted.
>>>> > > and
>>>> > > # cat /proc/mtrr
>>>> >
>>>>
>>>> There seems to be two different problems here.
>>>> - We should not have that many single page ranges reserved.
>>That will cause a
>>>> performance problem with drm even without the "freeing
>>invalid type" error.
>>>> - "freeing invalid type" error itself. Seems to be caused
>>due to some
>>>> unbalanced free along the drm path. We tried to find
>>anything obvious in the
>>>> code that may be causing problem here. But, haven't found
>>anything so far.
>>>> Will try to reproduce the problem internally and debug it further.
>>>>
>>>
>>> OK. I think we have root caused the thinko that was resulting in
>>> "freeing invalid type" error. Can you try the below test
>>> patch. Patch is not final version and may need some cleanup.
>>>
>>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>>>
>>> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
>>> index 640339e..c161700 100644
>>> --- a/arch/x86/mm/pat.c
>>> +++ b/arch/x86/mm/pat.c
>>> @@ -847,7 +847,8 @@ cleanup_ret:
>>>  * can be for the entire vma (in which case size can be zero).
>>>  */
>>>  void untrack_pfn_vma(struct vm_area_struct *vma, unsigned long pfn,
>>> -                       unsigned long size)
>>> +                       unsigned long size,
>>> +                       unsigned long vstart, unsigned long vend)
>>>  {
>>>        unsigned long i;
>>>        resource_size_t paddr;
>>> @@ -866,7 +867,7 @@ void untrack_pfn_vma(struct
>>vm_area_struct *vma, unsigned long pfn,
>>>                return;
>>>        }
>>>
>>> -       if (size != 0 && size != vma_size) {
>>> +       if (size != 0) {
>>>                /* free page by page, using pfn and size */
>>>                paddr = (resource_size_t)pfn << PAGE_SHIFT;
>>>                for (i = 0; i < size; i += PAGE_SIZE) {
>>> @@ -874,9 +875,12 @@ void untrack_pfn_vma(struct
>>vm_area_struct *vma, unsigned long pfn,
>>>                        free_pfn_range(paddr, PAGE_SIZE);
>>>                }
>>>        } else {
>>> -               /* free entire vma, page by page, using the
>>pfn from pte */
>>> -               for (i = 0; i < vma_size; i += PAGE_SIZE) {
>>> -                       if (follow_phys(vma, vma_start + i,
>>0, &prot, &paddr))
>>> +               /*
>>> +                * free vma range from vstart to end, page by page
>>> +                * using the pfn from pte
>>> +                */
>>> +               for (i = vstart; i < vend; i += PAGE_SIZE) {
>>> +                       if (follow_phys(vma, i, 0, &prot, &paddr))
>>>                                continue;
>>>
>>>                        free_pfn_range(paddr, PAGE_SIZE);
>>> diff --git a/include/asm-generic/pgtable.h
>>b/include/asm-generic/pgtable.h
>>> index 8e6d0ca..a325dc1 100644
>>> --- a/include/asm-generic/pgtable.h
>>> +++ b/include/asm-generic/pgtable.h
>>> @@ -328,7 +328,8 @@ static inline int
>>track_pfn_vma_copy(struct vm_area_struct *vma)
>>>  * can be for the entire vma (in which case size can be zero).
>>>  */
>>>  static inline void untrack_pfn_vma(struct vm_area_struct *vma,
>>> -                                       unsigned long pfn,
>>unsigned long size)
>>> +                               unsigned long pfn, unsigned
>>long size,
>>> +                               unsigned long vstart,
>>unsigned long vend)
>>>  {
>>>  }
>>>  #else
>>> @@ -336,7 +337,8 @@ extern int track_pfn_vma_new(struct
>>vm_area_struct *vma, pgprot_t *prot,
>>>                                unsigned long pfn, unsigned
>>long size);
>>>  extern int track_pfn_vma_copy(struct vm_area_struct *vma);
>>>  extern void untrack_pfn_vma(struct vm_area_struct *vma,
>>unsigned long pfn,
>>> -                               unsigned long size);
>>> +                               unsigned long size,
>>> +                               unsigned long vstart,
>>unsigned long vend);
>>>  #endif
>>>
>>>  #endif /* !__ASSEMBLY__ */
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index cf6873e..6e111c5 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -983,7 +983,7 @@ unsigned long unmap_vmas(struct
>>mmu_gather **tlbp,
>>>                        *nr_accounted += (end - start) >> PAGE_SHIFT;
>>>
>>>                if (unlikely(is_pfn_mapping(vma)))
>>> -                       untrack_pfn_vma(vma, 0, 0);
>>> +                       untrack_pfn_vma(vma, 0, 0, start, end);
>>>
>>>                while (start != end) {
>>>                        if (!tlb_start_valid) {
>>> @@ -1537,7 +1537,7 @@ int vm_insert_pfn(struct
>>vm_area_struct *vma, unsigned long addr,
>>>        ret = insert_pfn(vma, addr, pfn, pgprot);
>>>
>>>        if (ret)
>>> -               untrack_pfn_vma(vma, pfn, PAGE_SIZE);
>>> +               untrack_pfn_vma(vma, pfn, PAGE_SIZE, 0, 0);
>>>
>>>        return ret;
>>>  }
>>> @@ -1702,7 +1702,7 @@ int remap_pfn_range(struct
>>vm_area_struct *vma, unsigned long addr,
>>>        } while (pgd++, addr = next, addr != end);
>>>
>>>        if (err)
>>> -               untrack_pfn_vma(vma, pfn, PAGE_ALIGN(size));
>>> +               untrack_pfn_vma(vma, pfn, PAGE_ALIGN(size), 0, 0);
>>>
>>>        return err;
>>>  }
>>
>>2.6.29-git9 plus the above patch still doesn't fix my Dell
>>E6400 running
>> Fedora 10 x86_64:
>
> The patch here should get rid of the below msgs.
> http://marc.info/?l=linux-kernel&m=123862741914199&w=2
>
> Can you please test and check whether that resolves the problems?
>
> The patch inline in this mail above was a test patch to debug the
> another problem that only happens with recent X and that one we
> are still debugging. So you can ignore the above patch for now.
>
>
> Thanks,
> Venki

Thanks Venki - the messages are gone, but I appear to be far from
 having my graphical environment problems fixed...

- I still get

Apr  6 11:59:39 localhost kernel: [drm] Initialized drm 1.1.0 20060810
Apr  6 11:59:39 localhost kernel: pci 0000:00:02.0: PCI INT A -> GSI
16 (level, low) -> IRQ 16
Apr  6 11:59:39 localhost kernel: mtrr: type mismatch for
e0000000,10000000 old: write-back new: write-combining
Apr  6 11:59:39 localhost kernel: [drm] MTRR allocation failed.
Graphics performance may suffer.
Apr  6 11:59:39 localhost kernel: [drm] Initialized i915 1.6.0
20080730 for 0000:00:02.0 on minor 0
Apr  6 11:59:39 localhost kernel: mtrr: type mismatch for
e0000000,10000000 old: write-back new: write-combining

- I can't switch from X to VT (Alt-Fn) as my screen gets blank, no
 Caps Lock key led flashing when I hit the key, nothing else than a
 poweroff works

- I can't exit from X to VT as my screen gets flashing and scrolls
 what appears to be a prompt on the top of the screen instead of
 the bottom

F10 kernels behave the same way. 2.6.29.1 as well. Will test
 2.6.28 or earlier and report in a separate thread with full
 config details.

Thanks,

--alessandro

 "Sun keeps rising in the west / I keep on waking fully confused"

   (The Replacements, "Within Your Reach")
