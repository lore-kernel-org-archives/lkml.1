Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZHPNTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZHPNTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZHPNTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:19:09 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:65345 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbZHPNTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:19:08 -0400
Message-ID: <4A8807A3.3080604@colorfullife.com>
Date: Sun, 16 Aug 2009 15:20:35 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: npiggin@suse.de
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] ipc: sem preempt improve
References: <20090811110902.255877673@suse.de> <20090811111607.144736971@suse.de>
In-Reply-To: <20090811111607.144736971@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 01:09 PM, npiggin@suse.de wrote:
> The strange sysv semaphore wakeup scheme has a kind of busy-wait lock
> involved, which could deadlock if preemption is enabled during the
> "lock".
>
> It is an implementation detail (due to a spinlock being held) that this
> is actually the case. However if "spinlocks" are made preemptible, or if
> the sem lock is changed to a sleeping lock for example, then the wakeup
> would become buggy. So this might be a bugfix for -rt kernels.
>
> Imagine waker being preempted by wakee and never clearing IN_WAKEUP --
> if wakee has higher RT priority then there is a priority inversion deadlock.
> Even if there is not a priority inversion to cause a deadlock, then there
> is still time wasted spinning.
>
> Signed-off-by: Nick Piggin<npiggin@suse.de>
>    
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
