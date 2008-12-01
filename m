Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYLANC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYLANC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 08:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYLANCQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 08:02:16 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:38938 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYLANCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:02:15 -0500
Date: Mon, 1 Dec 2008 15:02:09 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       weidong.han@intel.com, mingo@redhat.com, avi@redhat.com,
       amit.shah@redhat.com
Subject: Re: [PATCH 3/9] add frontend implementation for the IOMMU API
Message-ID: <20081201130209.GA21615@il.ibm.com>
References: <1227800454-9555-4-git-send-email-joerg.roedel@amd.com> <20081128184041N.fujita.tomonori@lab.ntt.co.jp> <20081128113129.GO1386@amd.com> <20081201173830B.fujita.tomonori@lab.ntt.co.jp> <20081201120026.GF17719@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201120026.GF17719@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 01:00:26PM +0100, Joerg Roedel wrote:

> > > > The majority of the names (include/linux/iommu.h, iommu.c,
> > > > iommu_ops, etc) looks too generic? We already have lots of
> > > > similar things (e.g. arch/{x86,ia64}/asm/iommu.h, several
> > > > archs' iommu.c, etc). Such names are expected to be used by
> > > > all the IOMMUs.
> > > 
> > > The API is already useful for more than KVM. I also plan to
> > > extend it to support more types of IOMMUs than VT-d and AMD
> > > IOMMU in the future. But these changes are more intrusive than
> > > this patchset and need more discussion. I prefer to do small
> > > steps into this direction.
> > 
> > Can you be more specific? What IOMMU could use this? For example,
> > how GART can use this? I think that people expect the name 'struct
> > iommu_ops' to be an abstract for all the IOMMUs (or the majority
> > at least). If this works like that, the name is a good choice, I
> > think.
> 
> GART can't use exactly this. But with some extensions we can make it
> useful for GART and GART-like IOMMUs too. For example we can emulate
> domains in GART by partitioning the GART aperture space.

That would only work with a pvdma API, since GART doesn't support
multiple address spaces, and you don't get the isolation properties of
a real IOMMU, so... why would you want to do that?

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                       <->
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
