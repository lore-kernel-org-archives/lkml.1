Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZHYOTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZHYOTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbZHYOTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:19:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbZHYOTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:19:10 -0400
Subject: Re: [PATCH 2/3] inotify: do not BUG on idr entries at inotify
 destruction
From: Eric Paris <eparis@redhat.com>
To: "Mikko C." <mikko.cal@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       zdenek.kabelac@gmail.com, christoph.thielecke@gmx.de,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       grant.wilson@zen.co.uk
In-Reply-To: <4A93CE2A.90509@gmail.com>
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
	 <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
	 <20090824173812.14196.381.stgit@paris.rdu.redhat.com>
	 <200908242034.50885.elendil@planet.nl>
	 <1251140949.25096.16.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.LFD.2.01.0908241220590.3158@localhost.localdomain>
	 <1251146166.25096.22.camel@dhcp231-106.rdu.redhat.com>
	 <4A93CE2A.90509@gmail.com>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 10:18:24 -0400
Message-Id: <1251209904.2304.101.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 13:42 +0200, Mikko C. wrote:
> >> On Mon, 24 Aug 2009, Eric Paris wrote:
> >>>
> >>> You suspect correctly.  :(  I'll fix in my tree before I request a
> >>> pull....
> 
> I just got this with -rc7, but it doesn't look related to what I was 
> having before:
> 
> BUG: Bad page map in process kio_thumbnail  pte:ffff88006cc99128 
> pmd:6d3b1067
> addr:00007f9d4e3a5000 vm_flags:08000070 anon_vma:(null) 
> mapping:ffff88007abe21a0 index:200
> vma->vm_ops->fault: filemap_fault+0x0/0x460
> vma->vm_file->f_op->mmap: ext4_file_mmap+0x0/0x80
> Pid: 28022, comm: kio_thumbnail Not tainted 2.6.31-rc7 #1
> Call Trace:
>   [<ffffffff810afaf4>] ? print_bad_pte+0x1d4/0x2c0
>   [<ffffffff810afc79>] ? vm_normal_page+0x99/0xa0
>   [<ffffffff810b0c7d>] ? unmap_vmas+0x4cd/0x970
>   [<ffffffff810b6c74>] ? exit_mmap+0x104/0x1d0
>   [<ffffffff81043e0d>] ? mmput+0x4d/0x100
>   [<ffffffff81048d81>] ? exit_mm+0x101/0x150
>   [<ffffffff8104b240>] ? do_exit+0x6c0/0x750
>   [<ffffffff8104b326>] ? do_group_exit+0x56/0xd0
>   [<ffffffff8104b3c2>] ? sys_exit_group+0x22/0x40
>   [<ffffffff8100b7eb>] ? system_call_fastpath+0x16/0x1b
> Disabling lock debugging due to kernel taint
> 
> No lockups or anything.

I can safely say that I have absolutely no idea, but I'm doubting it is
mine.

Does everyone who hit the: kernel BUG at fs/notify/notification.c:93!
have CONFIG_DEBUG_VM=N ?   Mikko indicated that his problems seem to
crop up with CONFIG_DEBUG_VM=N but not when he enabled it.  I'll be
testing again today with it disabled.....

-Eric


