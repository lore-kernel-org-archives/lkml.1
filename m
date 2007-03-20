Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXCTV05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXCTV05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbXCTV0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:26:35 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41174 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbXCTV0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:26:33 -0400
Date: Tue, 20 Mar 2007 22:27:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- WARNING: could not find versions for .tmp_versions/built-in.mod
Message-ID: <20070320212705.GB13349@uranus.ravnborg.org>
References: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 07:35:06AM -0700, Miles Lane wrote:
> It looks like the number of section mismatches is much reduced, which
> is great.  But, I don't remember seeing "WARNING: could not find
> versions for ..." warnings before.  Is this an artifact of the
> init/.missing_syscalls.h problem I encountered earlier?
> 
>  MODPOST vmlinux
> WARNING: could not find versions for .tmp_versions/head.mod
> WARNING: could not find versions for .tmp_versions/init_task.mod
> WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> from .text between 'rest_init' (at offset 0x101) and 'try_name'
I do not see this one - but then I do not build the -mm tree.
Will chase it later if no-one beats me.

> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: could not find versions for .tmp_versions/built-in.mod
> WARNING: mm/built-in.o - Section mismatch: reference to
> .init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
> offset 0x15c8f) and '__section_nr'
I took a look at this one.
You have SPARSEMEM enabled in your config.
And then I see that in sparse.c we call alloc_bootmem_node()
from a function I thought should be marked __devinit (it
is used by memory_hotplug.c).
But I am not familiar enough to judge if __alloc_bootmen_node
are marked correct with __init or __devinit (to say
this is used in the HOTPLUG case) is more correct.
Anyone?

> WARNING: mm/built-in.o - Section mismatch: reference to
> .init.text:__alloc_bootmem_node from .text between 'sparse_init' (at
> offset 0x15d02) and '__section_nr'
Same as above....

> WARNING: mm/built-in.o - Section mismatch: reference to
> .init.data:initkmem_list3 from .text between 'set_up_list3s' (at
> offset 0x18c32) and 's_start'
This one I have also tried to track down. But my
slab knowledge was not enough to fix it :-(


	Sam
