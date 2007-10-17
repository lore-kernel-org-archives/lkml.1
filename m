Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbXJQRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbXJQRzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933148AbXJQRzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:55:24 -0400
Received: from gw.goop.org ([64.81.55.164]:52825 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765838AbXJQRzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:55:22 -0400
Message-ID: <47164C89.60400@goop.org>
Date: Wed, 17 Oct 2007 10:55:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] paravirt_ops and xen updates for 2.6.24
References: <47150D5E.6090504@goop.org>
In-Reply-To: <47150D5E.6090504@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hi Linus,
>   

Ping?

> Please pull:
>
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-upstream
>
> This contains updates for arch/x86 paravirt_ops and Xen.
>
> A quick overview of the patchset:
>
> paravirt_ops:
> 	Remove the monolithic paravirt_ops structure, and replace it with
> 	smaller structures of related functions.  Also, clean up the handling
> 	of lazy mode to make it easier to implement.
>
> x86/mm/init.c: remove a chunk of dead code
>
> Xen:
> 	- remove duplicate includes
> 	- yield if the target vcpu of an IPI is not currently running
> 	- add post-batch callbacks for multicalls [*]
> 	- deal with unpinning pagetables when another vcpu still
> 	  has a cr3 reference [*]
> 	- deal with split ptelocks by pinning each pte page
> 	  separately under lock
> 	- determine the kernel/hypervisor address split dynamically
> 	- use the right arg structure for register_vcpu_info [*]
> 	- add extra debugging output for failed multicalls
>
> XFS:
> 	- eagerly unmap vmapped areas to avoid confict with Xen [*]
>
> [*] bugfix needed for 2.6.23.  I've also cc:d them to stable@kernel.org
>
> Diffstat:
>  arch/x86/kernel/alternative.c         |    4 
>  arch/x86/kernel/asm-offsets_32.c      |   14 
>  arch/x86/kernel/entry_32.S            |    2 
>  arch/x86/kernel/paravirt_32.c         |  234 ++++++++-----
>  arch/x86/kernel/vmi_32.c              |  211 ++++++------
>  arch/x86/mm/init_32.c                 |   22 -
>  arch/x86/xen/enlighten.c              |  295 +++++++++-------
>  arch/x86/xen/mmu.c                    |  149 ++++++--
>  arch/x86/xen/multicalls.c             |   52 ++
>  arch/x86/xen/multicalls.h             |    5 
>  arch/x86/xen/smp.c                    |   14 
>  arch/x86/xen/time.c                   |    6 
>  arch/x86/xen/xen-ops.h                |   10 
>  drivers/char/hvc_lguest.c             |    2 
>  drivers/lguest/core.c                 |    6 
>  drivers/lguest/lguest.c               |  154 ++++----
>  drivers/lguest/lguest_bus.c           |    2 
>  fs/xfs/linux-2.6/xfs_buf.c            |   13 
>  include/asm-x86/paravirt.h            |  507 ++++++++++++++++-------------
>  include/asm-x86/pgtable-3level-defs.h |    2 
>  include/xen/interface/vcpu.h          |    5 
>  mm/Kconfig                            |    1 
>  22 files changed, 1027 insertions(+), 683 deletions(-)
>
> Thanks,
> 	J
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

