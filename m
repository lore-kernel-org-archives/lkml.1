Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYDITcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYDITcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYDITcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:32:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:46237 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYDITcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:32:00 -0400
Date: Wed, 9 Apr 2008 09:33:00 -1000 (HST)
From: Jeff Roberson <jroberson@jroberson.net>
X-X-Sender: jroberson@desktop
To: Davide Libenzi <davidel@xmailserver.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zach.brown@oracle.com, jroberson@chesapeake.net
Subject: Re: [patch] eventfd/kaio integration fix
In-Reply-To: <Pine.LNX.4.64.0804091217150.7000@alien.or.mcafeemobile.com>
Message-ID: <20080409093150.P43186@desktop>
References: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
 <20080409120812.cad8f173.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0804091217150.7000@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 9 Apr 2008, Davide Libenzi wrote:

> On Wed, 9 Apr 2008, Andrew Morton wrote:
>
>> On Wed, 9 Apr 2008 11:45:47 -0700 (PDT)
>> Davide Libenzi <davidel@xmailserver.org> wrote:
>>
>>> Jeff Roberson discovered a race when using kaio eventfd based
>>> notifications. This patch fixes the race by moving the notification inside
>>> the spinlocked section of kaio.
>>
>> Missing information.
>>
>> What are the consequences of this race, when it occurs?
>
> This was described in the original email. I posted a patch back then
> (waiting for Jeff test feedback - that never came), but then I forgot
> about it till now:
>
> http://groups.google.com/group/linux.kernel/browse_thread/thread/e814b54c14198616
>

I was thinking about stirring this up again myself.  Testing was 
complicated by several factors.  None of them related to this patch. 
However, I feel confident that this has solved our issue.

Jeff

>
>
>>> The operation is safe since eventfd
>>> spinlock and kaio one are unrelated.
>>
>> Yes, it's safe from that perspective.
>>
>> However with this patch applied, we will no longer run eventfd_signal() if
>> kiocbIsCancelled(iocb).  Convincing is needed, please?
>
> This was the intended behaviour. No event was actually *ready*, so no need
> to signal completion of an event.
>
>
>
> - Davide
>
>
