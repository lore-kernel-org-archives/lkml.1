Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYDWOrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYDWOrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 10:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYDWOqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 10:46:49 -0400
Received: from rtr.ca ([76.10.145.34]:1445 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYDWOqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 10:46:49 -0400
Message-ID: <480F4BD9.8090003@rtr.ca>
Date: Wed, 23 Apr 2008 10:46:49 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <480E70ED.3030701@rtr.ca> <20080423072432.GX12774@kernel.dk> <480F3CBC.60305@rtr.ca> <20080423135110.GO12774@kernel.dk>
In-Reply-To: <20080423135110.GO12774@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 23 2008, Mark Lord wrote:
>..
>> The second bug, is that for the halt case at least,
>> nobody waits for the other CPU to actually halt
>> before continuing.. so we sometimes enter the shutdown
>> code while other CPUs are still active.
>>
>> This causes some machines to hang at shutdown,
>> unless CPU_HOTPLUG is configured and takes them offline
>> before we get here.
> 
> I'm guessing there's a reason it doesn't pass '1' as the last argument,
> because that would fix that issue?
..

Undoubtedly -- perhaps the called CPU halts, and therefore cannot reply.  :)

But some kind of pre-halt ack, perhaps plus a short delay by the caller
after receipt of the ack, would probably suffice to kill that bug.

But I really haven't studied this code enough to know,
other than that it historically has been a sticky area
to poke around in.

Cheers
 

