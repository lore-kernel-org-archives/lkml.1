Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYHHARO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYHHARO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYHHAQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:16:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYHHAQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:16:58 -0400
Message-ID: <489B8FAD.4090904@kernel.org>
Date: Thu, 07 Aug 2008 17:13:33 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org> <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org> <489B8EF4.1030105@goop.org>
In-Reply-To: <489B8EF4.1030105@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> The Linux kernel was never a paragon of perfection - it was never 
>> meant to be.  Just because a bit of cruft went unnoticed into the 
>> kernel doesn't mean we shouldn't fix it.
> 
> I don't really see what the issue is.
> 
> Fixmaps are primarily used for things that need to be mapped early 
> before we can allocate address space dynamically.  They're predominantly 
> used for boot-time init, and rarely on any performance-critical path.  
> The only vaguely regular use a fixmap gets during runtime is poking at 
> apics, and that's dominated by IO time, and kmap_atomic.  Statically, 
> there's only 100 references in the kernel.  And it only affects 32-bit.
> 
> Having fixmaps at link-time fixed addresses would be nice, I suppose, 
> but hardly worth going to vast effort over.
> 

No, but it's hardly vast effort, either.

>>>> Given the x86 architecture, it's inevitable that PV will want to 
>>>> reserve address space at the top of memory, and therefore the fixmap 
>>>> area needs to be moved out of that space.
>>>
>>> OK.  But there's a few places where the code uses FIXADDR_TOP to mean 
>>> "top of kernel address space", so we'd need to come up with a proper 
>>> symbol for that.
>>
>> I suggest KERNEL_TOP.
> 
> Fine by me.  It would be easy to plug KERNEL_TOP/__KERNEL_TOP in now, 
> and then fix up fixmap independently.

Yes, and we should add a symbol for the bottom of the 1:1 area as well 
(to disambiguate it from TASK_SIZE).

	-hpa

