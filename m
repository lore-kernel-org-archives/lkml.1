Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZJOHJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZJOHJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 03:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZJOHJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 03:09:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbZJOHJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 03:09:49 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7d86d44a0910142045n585c099l50b1efec12c1db3e@mail.gmail.com>
References: <7d86d44a0910142045n585c099l50b1efec12c1db3e@mail.gmail.com> <1255516134-4838-1-git-send-email-graff.yang@gmail.com> <18475.1255529305@redhat.com> <7d86d44a0910141921j28ddc50cxb2d9386c5ad99db9@mail.gmail.com>
To: graff yang <graff.yang@gmail.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       gyang@blackfin.uclinux.org, akpm@linux-foundation.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graf.yang@analog.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] mm/nommu.c: Fix improperly call of security API in mmap
Date: Thu, 15 Oct 2009 08:07:21 +0100
Message-ID: <6954.1255590441@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

graff yang <graff.yang@gmail.com> wrote:

> Your patch works both with SELINUX enabled or disabled.

Thanks.

> But, how to prevent the address that attempting to be mapped to be lower
> than CONFIG_LSM_MMAP_MIN_ADDR/CONFIG_DEFAULT_MMAP_MIN_ADDR?
> This is what the security_file_mmap() is doing and mmu's
> do_mmap_pgoff() has implemented.

You need to ask yourself two questions:

 (1) Does the test make any sense in the NOMMU context?  Given that the
     userspace program _cannot_ specify that something should be mapped below
     that address (since MAP_FIXED gives an error and the hint is ignored),
     I'd say not.

 (2) Is it likely that LSM security would be used with NOMMU anyway, given
     that there is nothing stopping userspace programs editing the kernel
     directly?

You need to show that it makes sense to do the test in a NOMMU context.
Remember, if there is no physical medium at address 0 (RAM, flash, whatever),
you can't map anything there.  This might best be left to the arch to not
provide page 0 of RAM to the page allocator during memory initialisation.

David
