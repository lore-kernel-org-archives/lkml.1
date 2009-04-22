Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZDVTe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZDVTe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZDVTeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:34:46 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:52371 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZDVTep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:34:45 -0400
Message-ID: <49EF70E1.9030904@nortel.com>
Date: Wed, 22 Apr 2009 13:32:49 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
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
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera> <alpine.LFD.2.00.0904061443000.7443@localhost.localdomain> <200904070035.00784.rjw@sisk.pl> <49E79E58.9000606@nortel.com> <alpine.LFD.2.00.0904161432000.4042@localhost.localdomain> <49ECE783.5050704@nortel.com> <Pine.LNX.4.64.0904202352520.2924@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0904202352520.2924@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2009 19:32:52.0713 (UTC) FILETIME=[20E95590:01C9C381]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Mon, 20 Apr 2009, Chris Friesen wrote:

>> For anonymous mappings, the older kernels put the starting address of the VMA
>> (from the point of view of the app) as the offset.  Until the recent change,
>> new kernels still did this for most VMAs, but the stack offset was a 64-bit
>> value with no obvious relation to the VMA start address.
> 
> No, what they put there was something that in most cases matched the
> starting address of the VMA; but try moving that VMA with mremap (and
> an old /proc/<pid>/maps!) and you'll see that the "offset" remained
> unchanged even when the starting address of the VMA was changed.
> 
> (The offset remaining constant so that rmap can locate the VMA's pages
> and unmap them, despite their being mapped at different virtual
> addresses in parent and child after a move in one of them.)
> 
> ... so I think your app was indeed already broken, wasn't it?
> 
> It's also unclear why you'd want to use the offset field for the
> starting address of the VMA, when /proc/<pid>/maps already shows
> the starting address of the VMA.  I think you've more to tell us!

Yeah, given the above the app was broken.  We just didn't run into any 
cases where the assumption caused any problems.

Also, it's not so much that we were relying on the offset value for 
anything, so much as we were parsing the file and had made some 
assumptions about valid offsets for anonymous memory.

Anyways, we'll fix it going forward to simply ignore the offset for 
anonymous memory.

Chris
