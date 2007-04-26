Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbXDZGP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbXDZGP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbXDZGP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:15:27 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47908 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbXDZGPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:15:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Jack Morgenstein <jackm@mellanox.co.il>
Subject: Re: pgprot_writecombine() and PATs on x86
References: <ada1wi8xrgt.fsf@cisco.com> <adaodlcwbdo.fsf@cisco.com>
	<m11wi8s36o.fsf@ebiederm.dsl.xmission.com>
	<20070426054333.GN5217@mellanox.co.il>
Date: Thu, 26 Apr 2007 00:13:44 -0600
In-Reply-To: <20070426054333.GN5217@mellanox.co.il> (Michael S. Tsirkin's
	message of "Thu, 26 Apr 2007 08:43:33 +0300")
Message-ID: <m1647joe7b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@dev.mellanox.co.il> writes:

>> So in general the pci prefetchable attribute means write-combining as
>> well as prefetching is safe.  A sane BIOS will allocate prefetchable
>> BARS contiguously in the address space.  So on a good day you
>> can just use one MTRR to map all of the prefetchable BARs as write-combining.
>
> Good point, and sounds easy enough.
> So why does not linux do it automatically then where possible?

It does when we have support in the page tables.  The MTRRs appear
to complex to use automatically.  Getting the all of the memory
set to write-back using the can be a chore.  If things were truly
straight forward every BIOS would setup write-combining automatically.

> There are sure to be some broken devices, but if some device
> can't live with WC, we can always disable WC system-wide.

Yes.

Eric
