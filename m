Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbYDUWiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbYDUWiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYDUWiC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:38:02 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:47188 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYDUWiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:38:00 -0400
Date: Mon, 21 Apr 2008 15:37:51 -0700
From: Brandon Philips <brandon@ifup.org>
To: Gregor Jasny <jasny@vidsoft.de>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.25 regression: vivi - scheduling while atomic
Message-ID: <20080421223751.GD9073@plankton.ifup.org>
References: <20080421081639.GE26724@vidsoft.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421081639.GE26724@vidsoft.de>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:16 Mon 21 Apr 2008, Gregor Jasny wrote:
> Call Trace:
>  [<ffffffff803efc9b>] schedule+0xe5/0x5c7
>  [<ffffffff80251c90>] __rmqueue_smallest+0x88/0x107
>  [<ffffffff8023e84b>] getnstimeofday+0x2f/0x83
>  [<ffffffff8023cf8a>] ktime_get_ts+0x17/0x48
>  [<ffffffff803f0424>] schedule_timeout+0x1e/0xad
>  [<ffffffff80220498>] enqueue_task+0x13/0x1e
>  [<ffffffff803efab8>] wait_for_common+0xf6/0x16b
>  [<ffffffff802230a0>] default_wake_function+0x0/0xe
>  [<ffffffff8023a270>] kthread_create+0xa3/0x108
>  [<ffffffff880d2471>] :vivi:vivi_thread+0x0/0x779
>  [<ffffffff802634cb>] remap_vmalloc_range+0xa1/0xe6
>  [<ffffffff80231242>] lock_timer_base+0x26/0x4c
>  [<ffffffff8023138e>] __mod_timer+0xb6/0xc5
>  [<ffffffff880d23fc>] :vivi:vivi_start_thread+0x54/0xc9
>  [<ffffffff88053603>] :videobuf_core:videobuf_streamon+0x6c/0xaa
>  [<ffffffff8809dba3>] :videodev:__video_do_ioctl+0x1327/0x2ad9
>  [<ffffffff80222d76>] __wake_up+0x38/0x4f
>  [<ffffffff80242f1f>] futex_wake+0xdb/0xfa
>  [<ffffffff8809f6ab>] :videodev:video_ioctl2+0x17c/0x210
>  [<ffffffff8025bb36>] handle_mm_fault+0x6b1/0x6cb
>  [<ffffffff8027b47d>] vfs_ioctl+0x55/0x6b
>  [<ffffffff8027b6e6>] do_vfs_ioctl+0x253/0x264
>  [<ffffffff8027b733>] sys_ioctl+0x3c/0x5d
>  [<ffffffff8020afcb>] system_call_after_swapgs+0x7b/0x80
>
> This happenes on a vanilla 2.6.25 with loaded nvidia graphics module.
> System architecture is x86_64. If it matters I'll try to reproduce this
> error on a non tainted kernel.

No need to reproduce on a non-tainted Kernel.  This is a known issue
with patches merged into the v4l-dvb tree several weeks ago but it seems
to not have made it into 2.6.25 :(

 http://linuxtv.org/hg/v4l-dvb/rev/06eb92ed0b18
 http://linuxtv.org/hg/v4l-dvb/rev/c50180f4ddfc

I can rebase the patches for 2.6.25 but they are too big to go into the
stable 2.6.25 tree...

Thanks for the report,

	Brandon
