Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYHMIgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYHMIgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHMIgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:36:32 -0400
Received: from il.qumranet.com ([212.179.150.194]:54376 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbYHMIgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:36:31 -0400
Message-ID: <48A29D0D.9010801@qumranet.com>
Date: Wed, 13 Aug 2008 11:36:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Max Krasnyansky <maxk@qualcomm.com>
CC: LKML <linux-kernel@vger.kernel.org>, andrea@qumranet.com
Subject: Re: Circular vma locking with kvm, seems to be mmu notifiers related
References: <48A0D6A9.4030603@qualcomm.com>
In-Reply-To: <48A0D6A9.4030603@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Krasnyansky wrote:
> Got this on the latest mainline git.
> There are already a couple of lockdep/kvm threads. So maybe it's known.
>
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.27-rc2 #36
> ---------------------------------------------
> qemu-system-x86/3445 is trying to acquire lock:
>  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
>
> but task is already holding lock:
>  (&anon_vma->lock){--..}, at: [<ffffffff8029f84d>] mm_take_all_locks+0x8d/0xf0
>
>   

Seems to be a false positive.  mmu_take_all_locks takes (surprise!) all 
anon_vma->locks belonging to an mm, and takes special care not to 
deadlock while doing this.

We need to communicate this to lockdep somehow.

-- 
error compiling committee.c: too many arguments to function

