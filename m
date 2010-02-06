Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0BFKaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 05:30:05 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46338 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0BFK37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 05:29:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aealaMiYhGB8WkqDpuS8Z7/LDhsjgxqs+EGXI/jTh9gnFVN18XYO6jbo3C3JsosKbt
         tHgkLwUh2/du/4lY5/o2BPVC155GlYniFBowVF+xQ896HLXq0jENDb8RHcb+D/plZkBv
         O150oM4TSE9BsHVre0Pg4rv4IBHgb8zTdETG0=
Date: Sat, 6 Feb 2010 11:29:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: reiserfs deadlock
Message-ID: <20100206102945.GA5062@nowhere>
References: <a4423d671002031103r230f66cai4ab25236504bcf15@mail.gmail.com> <a4423d671002031108x6c2682edl9a147c35ac9c2815@mail.gmail.com> <20100203202909.GA5068@nowhere> <a4423d671002031443q283bab49wd15cd4de556d9557@mail.gmail.com> <20100203225232.GI5068@nowhere> <a4423d671002041746q1d918972i7c180d38a7c1d52@mail.gmail.com> <20100205035953.GB5408@nowhere> <20100205093752.GA13441@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205093752.GA13441@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 12:37:52PM +0300, Alexander Beregalov wrote:
> INFO: task nfsd:1741 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> nfsd          D 38f62cfa  6636  1741      2 0x00000000
>  f62d3c50 00000046 f62d3c30 38f62cfa 0000000b f6206b30 f62068b0 f62d3c90
>  f62d3c58 f62d3c88 00000000 f62d3c90 f62d3c58 c10a4838 f62d3c74 c134dc75
>  c10a4830 c27efab8 c27efab8 f6fbbf9c f62d3ca4 f62d3cb0 c134dd00 00000002
> Call Trace:
>  [<c10a4838>] inode_wait+0x8/0x10
>  [<c134dc75>] __wait_on_bit+0x45/0x70
>  [<c10a4830>] ? inode_wait+0x0/0x10
>  [<c134dd00>] out_of_line_wait_on_bit+0x60/0x70
>  [<c10a4830>] ? inode_wait+0x0/0x10
>  [<c103d530>] ? wake_bit_function+0x0/0x50
>  [<c10a51dc>] ifind+0x8c/0xb0
>  [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
>  [<c10a5f90>] iget5_locked+0x40/0x170
>  [<c10ea460>] ? reiserfs_find_actor+0x0/0x30
>  [<c10ec554>] reiserfs_iget+0x34/0xb0
>  [<c10ea440>] ? reiserfs_init_locked_inode+0x0/0x20
>  [<c10ec5f9>] reiserfs_get_dentry+0x29/0x70
>  [<c1042c55>] ? sched_clock_cpu+0x95/0x110
>  [<c10ec6cf>] reiserfs_fh_to_dentry+0x3f/0xb0
>  [<c1128b85>] exportfs_decode_fh+0x35/0x200
>  [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
>  [<c133fbc0>] ? cache_check+0x30/0x330
>  [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
>  [<c108cab4>] ? slab_pad_check+0x34/0x120
>  [<c11305fa>] ? exp_get_by_name+0x4a/0x70
>  [<c134018c>] ? sunrpc_cache_lookup+0x5c/0x140
>  [<c108ce74>] ? check_object+0xe4/0x200
>  [<c108d470>] ? init_object+0x40/0x70
>  [<c104e202>] ? mark_held_locks+0x62/0x90
>  [<c108ed55>] ? kmem_cache_alloc+0xa5/0xf0
>  [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
>  [<c104e51b>] ? trace_hardirqs_on+0xb/0x10
>  [<c1042de2>] ? prepare_creds+0x22/0x50
>  [<c1042de2>] ? prepare_creds+0x22/0x50
>  [<c112c3a7>] fh_verify+0x2f7/0x580
>  [<c112bf50>] ? nfsd_acceptable+0x0/0xf0
>  [<c102ea21>] ? local_bh_enable_ip+0x61/0xc0
>  [<c104e4c4>] ? trace_hardirqs_on_caller+0x124/0x170
>  [<c13422ab>] ? svc_xprt_enqueue+0x7b/0x240
>  [<c1135245>] nfsd3_proc_getattr+0x55/0xb0
>  [<c1129055>] nfsd_dispatch+0x95/0x200
>  [<c133697a>] svc_process+0x40a/0x730
>  [<c1129654>] nfsd+0xa4/0x130
>  [<c11295b0>] ? nfsd+0x0/0x130
>  [<c103d1fc>] kthread+0x6c/0x80
>  [<c103d190>] ? kthread+0x0/0x80
>  [<c100303a>] kernel_thread_helper+0x6/0x1c
> 2 locks held by nfsd/1741:
>  #0:  (hash_sem){.+.+.+}, at: [<c1131a2d>] exp_readlock+0xd/0x10
>  #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110f28>] reiserfs_write_lock+0x28/0x40


Yes! That must be the culprit. We are waiting for the inode to be
un-dirtied, but it can't since the writeback will need the reiserfs lock,
which we hold already.

Fine, I'll fix this, thanks a lot again for your report Alexander!

