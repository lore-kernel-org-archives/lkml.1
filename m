Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXKJWzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXKJWzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXKJWzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:55:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755175AbXKJWzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:55:23 -0500
Date: Sat, 10 Nov 2007 14:54:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING: at lib/kref.c:33 kref_get() (-mm 2007-11-06-02-32++)
Message-Id: <20071110145452.f6cf6326.akpm@linux-foundation.org>
In-Reply-To: <200711100212.lAA2Cll0015004@agora.fsl.cs.sunysb.edu>
References: <200711100212.lAA2Cll0015004@agora.fsl.cs.sunysb.edu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2007 21:12:47 -0500 Erez Zadok <ezk@cs.sunysb.edu> wrote:

> Setup: FC6 system with MM snapshot broken-out-2007-11-06-02-32

That's a bit old.

> and these two
> patches added:
> 
> r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
> r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
> 
> Booting the machine, waiting a few minutes (not logging in or doing anything
> else).  I get:
> 
> WARNING: at lib/kref.c:33 kref_get()
>  [<c020282a>] show_trace_log_lvl+0x12/0x25
>  [<c0203024>] show_trace+0xd/0x10
>  [<c0203120>] dump_stack+0x15/0x17
>  [<c02c7f85>] kref_get+0x26/0x30
>  [<c02c731b>] kobject_get+0x12/0x17
>  [<c02c7770>] kobject_add+0x97/0x162
>  [<c02164e5>] uids_user_create+0x41/0x5d
>  [<c0216850>] alloc_uid+0xc9/0x171
>  [<c0219b50>] set_user+0x1f/0x93
>  [<c021b445>] sys_setuid+0x4b/0xcb
>  [<c02021fe>] sysenter_past_esp+0x5f/0x91
>  =======================
> 
> There's no other indication where the setuid(2) came from, perhaps cron?
> 

I have a feeling that this was reported before and that Dave and/or Greg
looked into it.  Were those two patches which Dave sent yesterday applied?

It might be worth checking my current tree:
http://userweb.kernel.org/~akpm/mmotm/
