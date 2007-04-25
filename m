Return-Path: <linux-kernel-owner+w=401wt.eu-S1030757AbXDYSuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030757AbXDYSuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030856AbXDYSuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:50:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41445 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030757AbXDYSug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:50:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Roland Dreier <rdreier@cisco.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, mst@mellanox.co.il,
       jackm@mellanox.co.il
Subject: Re: pgprot_writecombine() and PATs on x86
References: <ada1wi8xrgt.fsf@cisco.com> <200704252019.28017.ak@suse.de>
	<m1abwws3uh.fsf@ebiederm.dsl.xmission.com> <adaodlcwbdo.fsf@cisco.com>
Date: Wed, 25 Apr 2007 12:45:51 -0600
In-Reply-To: <adaodlcwbdo.fsf@cisco.com> (Roland Dreier's message of "Wed, 25
	Apr 2007 11:35:15 -0700")
Message-ID: <m11wi8s36o.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> writes:

>  > Roland is the mlx4 sane enough to put the memory that needs
>  > write-combining a prefetchable bar.  So several cards can be combined
>  > together?
>
> Yes, it is in a prefetchable BAR.  It's the second half of the second
> BAR in:
>
>     0d:00.0 InfiniBand: Mellanox Technologies Unknown device 634a (rev a0)
>             Subsystem: Mellanox Technologies Unknown device 634a
>             Flags: bus master, fast devsel, latency 0, IRQ 16
>             Memory at fc400000 (64-bit, non-prefetchable) [size=1M]
>             Memory at d8000000 (64-bit, prefetchable) [size=8M]
>             Memory at fc3fe000 (64-bit, non-prefetchable) [size=8K]
>             Capabilities: <access denied>
>
> but I'm not sure what you mean about combining several cards?

So in general the pci prefetchable attribute means write-combining as
well as prefetching is safe.  A sane BIOS will allocate prefetchable
BARS contiguously in the address space.  So on a good day you
can just use one MTRR to map all of the prefetchable BARs as write-combining.

Eric
