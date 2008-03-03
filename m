Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbYCCRi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbYCCRi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbYCCRbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:31:05 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:34111 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762425AbYCCRbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:31:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACrEy0dMQWoK/2dsb2JhbACBVqtl
Date: Mon, 3 Mar 2008 12:30:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>
Subject: Re: bad paravirt/Xen interaction in "x86 - Enhance DEBUG_RODATA
	support - alternatives"
Message-ID: <20080303173057.GA14598@Krystal>
References: <47C86D7A.5030608@goop.org> <47C8717F.3030009@zytor.com> <47C87488.9030205@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47C87488.9030205@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:27:11 up 3 days, 13:38,  6 users,  load average: 0.52, 0.23,
	0.28
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> H. Peter Anvin wrote:
>> Jeremy Fitzhardinge wrote:
>>> The patch "x86 - Enhance DEBUG_RODATA support - alternatives" enables the 
>>> kernel for writing by clearing X86_CR0_WP allow privileged writes.  This 
>>> won't work in a paravirt environment for two reasons:
>>>
>>>   1. the kernel may not be running in ring 0, so writes will still be
>>>      prevented
>>>   2. the hypervisor prevents X86_CR0_WP from being cleared anyway (it
>>>      GPFs the cr0 update)
>>>
>>> This crashes on Xen, and it would probably break VMI too.
>
> (lguest too, of course)
>
>>> The only safe way to allow writes is to change the page permissions 
>>> (either on the page itself, or create a temporary writable alias for that 
>>> page).  Perhaps something you could do it with kmap_atomic.
>>>
>>
>> A properly implemented hypervisor should arguably emulate this.
>>
>> Doesn't really mean the patch is worth the pain.
>
> No, it would be irritating to implement.
>
> Seems to me that doing the update in a temporary kmap_atomic mapping would 
> be a more straightforward way to go, anyway.  How would you implement this 
> on a processor without something like X86_CR0_WP?
>
>    J

I think kmap_atomic is only implemented on x86_32 and only deals with
highmem pages. It will simply return the original page address without
changing the protection for other pages, which is not what we want.
Would ioremap() be a good alternative ?

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
