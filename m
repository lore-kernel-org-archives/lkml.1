Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbYHHGKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbYHHGKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbYHHGKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:10:42 -0400
Received: from gw.goop.org ([64.81.55.164]:53181 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYHHGKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:10:41 -0400
Message-ID: <489BE351.5030206@goop.org>
Date: Thu, 07 Aug 2008 23:10:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Zachary Amsden <zach@vmware.com>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org> <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com> <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org> <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org> <489B8EF4.1030105@goop.org> <489B8FAD.4090904@kernel.org>
In-Reply-To: <489B8FAD.4090904@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>>
>>> The Linux kernel was never a paragon of perfection - it was never 
>>> meant to be.  Just because a bit of cruft went unnoticed into the 
>>> kernel doesn't mean we shouldn't fix it.
>>
>> I don't really see what the issue is.
>>
>> Fixmaps are primarily used for things that need to be mapped early 
>> before we can allocate address space dynamically.  They're 
>> predominantly used for boot-time init, and rarely on any 
>> performance-critical path.  The only vaguely regular use a fixmap 
>> gets during runtime is poking at apics, and that's dominated by IO 
>> time, and kmap_atomic.  Statically, there's only 100 references in 
>> the kernel.  And it only affects 32-bit.
>>
>> Having fixmaps at link-time fixed addresses would be nice, I suppose, 
>> but hardly worth going to vast effort over.
>>
>
> No, but it's hardly vast effort, either.

Thinking about it, the fixmap really has to be as high as possible.  If 
it were any lower, then it would either truncate the 1:1 mapping, or 
shadow some physical memory.

    J
