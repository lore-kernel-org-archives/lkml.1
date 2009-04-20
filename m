Return-Path: <linux-kernel-owner+w=401wt.eu-S1757728AbZDTVX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728AbZDTVX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbZDTVXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:23:40 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:55226 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbZDTVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:23:38 -0400
Message-ID: <49ECE783.5050704@nortel.com>
Date: Mon, 20 Apr 2009 15:22:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Trenton Adams <trenton.d.adams@gmail.com>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain> <200904070035.00784.rjw@sisk.pl> <49E79E58.9000606@nortel.com> <alpine.LFD.2.00.0904161432000.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904161432000.4042@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Apr 2009 21:22:13.0741 (UTC) FILETIME=[12C341D0:01C9C1FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 16 Apr 2009, Chris Friesen wrote:
>> I'm okay with that.  The problem causes some backwards compatibility problems
>> with existing apps that get confused by the large "offset" number.  The fix is
>> going to cause problems too, but in a different way.
>>
>> We'll work around it.
> 
> If you have actual apps that care, that's a different issue.
> 
> We do try to bend over backwards on ABI issues if it really is noticeable 
> for applications. Now, in this case, if you can just fix your app to not 
> care (because it really was badly written in the first place to even 
> notice), then that is the _much_ superior solution.

Yep, we can fix the app to ignore that field for anonymous mappings.

> Although I don't really even see what we can sanely do except for the 0 
> case. We could put the virtual address in there instead of zero (I forget 
> what old kernels used to do - whatever magic value the anonymous mappings 
> got, it wasn't really designed as an important value in its own right, it 
> was designed to trigger the "we can merge these vma's" logic.

For anonymous mappings, the older kernels put the starting address of 
the VMA (from the point of view of the app) as the offset.  Until the 
recent change, new kernels still did this for most VMAs, but the stack 
offset was a 64-bit value with no obvious relation to the VMA start address.

Chris
