Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbYBDSiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbYBDSiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYBDSil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:38:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756134AbYBDSik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:38:40 -0500
Date: Mon, 4 Feb 2008 13:38:10 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [mm] Crashkernel memory reservation fails with 2.6.24-rc8-mm1
Message-ID: <20080204183810.GE16021@redhat.com>
References: <47A7391F.2020408@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A7391F.2020408@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 09:41:11PM +0530, Sachin P. Sant wrote:
> While trying to configure kdump with 2.6.24-rc8-mm1 [ on a x86-64 box ]
> i ran into this problem. Here is the snippet from dmesg during the
> failure. [ dmesg log attached ]
>
> early_ioremap(000000000000040e, 00000002) => -000002103442418
> early_iounmap(ffffffff82a0040e, 00000002)
> early_ioremap(000000000009dc00, 00001000) => -000002102797312
> early_iounmap(ffffffff82a9dc00, 00001000)
> crashkernel reservation failed - memory is in use
> [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
> [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
> [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
> [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
>
> I am using 128M@32M value for crashkernel parameter.
>

Hmm..., So somebody has already reserved the memory we are trying to
reserve. Bernhard's BOOTMEM_EXCLUSIVE flag is atleast giving the warning
otherwise it would have silently created an overlapping reserved memory
area.

Sachin, can you please put some debugging statements before the calls
to reserve_bootmem() in arch/x86 to find out who all are reserving what
memory area and then we can nail down the guy who is reserving some
memory between 32M and 160M

Wished we had some debugging printk statements for reserve_bootmem too
(the way we have for early_ioremap and early_iounmap).

Bernahard, any idea who is the competitor here?

Thanks
Vivek
