Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbXENRna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbXENRna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756318AbXENRnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:43:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:19183 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbXENRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iOCuOFpGFoz7QHUTUIic3G+4YvLUIDhtFGqyiXQzwdKO+i3QR1vAyLc3os7yBECnZjziKY7yBh4KxzfaaeU+qfx/GBFHEikAXFyh2fGMY52A1B1jW87CTLM6iquJraRX4O95f7Jux5OGsJEUQuS22sGXby8G5sPI+LCZeqxyNPg=
Message-ID: <6bffcb0e0705141043m6a5b7d22p11ec15723f3f8593@mail.gmail.com>
Date: Mon, 14 May 2007 19:43:18 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Folkert van Heusden" <folkert@vanheusden.com>
Subject: Re: [2.6.21] circular locking dependency found in QUOTA OFF
Cc: "Jan Kara" <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <3262.62.177.207.163.1179152484.squirrel@klant.bhosted.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no>
	 <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca>
	 <m33b208z5f.fsf@maximus.localdomain> <46479E95.6050507@tmr.com>
	 <20070513235341.GA4270@havoc.gtf.org> <46486DEC.1080506@tmr.com>
	 <3262.62.177.207.163.1179152484.squirrel@klant.bhosted.nl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[adding Jan and fsdevel to CC]

Hi Folkert,

On 14/05/07, Folkert van Heusden <folkert@vanheusden.com> wrote:
> Hi,
>
> When I cleanly reboot my pc running 2.6.21 on a P4 with HT and 2GB of ram
> and system on an 1-filesystem IDE disk, I get the following circular
> locking dependency error:
>
> [330961.226405] =======================================================
> [330961.226489] [ INFO: possible circular locking dependency detected ]
> [330961.226531] 2.6.21 #5
> [330961.226569] -------------------------------------------------------
> [330961.226611] quotaoff/12249 is trying to acquire lock:
> [330961.226652]  (&sb->s_type->i_mutex_key#4){--..}, at: [<c120e2a1>]
> mutex_lock+0x8/0xa
> [330961.226861]
> [330961.226862] but task is already holding lock:
> [330961.226938]  (&s->s_dquot.dqonoff_mutex){--..}, at: [<c120e2a1>]
> mutex_lock+0x8/0xa
> [330961.227111]
> [330961.227111] which lock already depends on the new lock.
> [330961.227112]
> [330961.227225]
> [330961.227225] the existing dependency chain (in reverse order) is:
> [330961.227303]
> [330961.227303] -> #1 (&s->s_dquot.dqonoff_mutex){--..}:
> [330961.227473]        [<c1039b02>] check_prev_add+0x15b/0x281
> [330961.227766]        [<c1039cb3>] check_prevs_add+0x8b/0xe8
> [330961.228056]        [<c103b683>] __lock_acquire+0x692/0xb81
> [330961.228353]        [<c103bfda>] lock_acquire+0x62/0x81
> [330961.228643]        [<c120e322>] __mutex_lock_slowpath+0x75/0x28c
> [330961.228934]        [<c120e2a1>] mutex_lock+0x8/0xa
> [330961.229221]        [<c109fbbe>] vfs_quota_on_inode+0xc1/0x25f
> [330961.229513]        [<c109fdd1>] vfs_quota_on+0x75/0x79
> [330961.229803]        [<c10bc92d>] ext3_quota_on+0x95/0xb0
> [330961.230093]        [<c10a1eb2>] do_quotactl+0xc9/0x2dd
> [330961.230384]        [<c10a214a>] sys_quotactl+0x84/0xd6
> [330961.230673]        [<c1003f74>] syscall_call+0x7/0xb
> [330961.230963]        [<ffffffff>] 0xffffffff
> [330961.231268]
> [330961.231268] -> #0 (&sb->s_type->i_mutex_key#4){--..}:
> [330961.231469]        [<c10399db>] check_prev_add+0x34/0x281
> [330961.231759]        [<c1039cb3>] check_prevs_add+0x8b/0xe8
> [330961.232049]        [<c103b683>] __lock_acquire+0x692/0xb81
> [330961.232344]        [<c103bfda>] lock_acquire+0x62/0x81
> [330961.232632]        [<c120e322>] __mutex_lock_slowpath+0x75/0x28c
> [330961.232923]        [<c120e2a1>] mutex_lock+0x8/0xa
> [330961.233211]        [<c109fa6c>] vfs_quota_off+0x1cf/0x260
> [330961.233500]        [<c10a2088>] do_quotactl+0x29f/0x2dd
> [330961.233792]        [<c10a214a>] sys_quotactl+0x84/0xd6
> [330961.234081]        [<c1003f74>] syscall_call+0x7/0xb
> [330961.234503]        [<ffffffff>] 0xffffffff
> [330961.234795]
> [330961.234795] other info that might help us debug this:
> [330961.234796]
> [330961.234908] 2 locks held by quotaoff/12249:
> [330961.234947]  #0:  (&type->s_umount_key#15){----}, at: [<c1070b5d>]
> get_super+0x53/0x94
> [330961.235183]  #1:  (&s->s_dquot.dqonoff_mutex){--..}, at: [<c120e2a1>]
> mutex_lock+0x8/0xa
> [330961.235386]
> [330961.235387] stack backtrace:
> [330961.235462]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [330961.235535]  [<c1004d7b>] show_trace+0x12/0x14
> [330961.235606]  [<c1004e75>] dump_stack+0x16/0x18
> [330961.235679]  [<c1039352>] print_circular_bug_tail+0x6f/0x71
> [330961.235753]  [<c10399db>] check_prev_add+0x34/0x281
> [330961.235825]  [<c1039cb3>] check_prevs_add+0x8b/0xe8
> [330961.235897]  [<c103b683>] __lock_acquire+0x692/0xb81
> [330961.235969]  [<c103bfda>] lock_acquire+0x62/0x81
> [330961.236041]  [<c120e322>] __mutex_lock_slowpath+0x75/0x28c
> [330961.236113]  [<c120e2a1>] mutex_lock+0x8/0xa
> [330961.236185]  [<c109fa6c>] vfs_quota_off+0x1cf/0x260
> [330961.236257]  [<c10a2088>] do_quotactl+0x29f/0x2dd
> [330961.236330]  [<c10a214a>] sys_quotactl+0x84/0xd6
> [330961.236402]  [<c1003f74>] syscall_call+0x7/0xb
> [330961.236473]  =======================
>

Is this a 2.6.21 regression?

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
