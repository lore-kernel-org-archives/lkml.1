Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbYLDKrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbYLDKrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 05:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYLDKrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 05:47:14 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:39161 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYLDKrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 05:47:13 -0500
Date: Thu, 4 Dec 2008 05:47:02 -0500
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Greg KH <gregkh@suse.de>, Joerg Roedel <joerg.roedel@amd.com>,
       kvm@vger.kernel.org, Han Weidong <weidong.han@intel.com>,
       linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>,
       iommu@lists.linux-foundation.org, Ingo Molnar <mingo@redhat.com>,
       Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/12] Factor VT-d KVM functions into a generic API
	(with multiple device assignment support)
Message-ID: <20081204104702.GE5541@il.ibm.com>
References: <1228222883-17207-1-git-send-email-joerg.roedel@amd.com> <20081203034405.GA23835@suse.de> <20081203075049.GN29705@8bytes.org> <20081203075302.GA13420@suse.de> <20081203090304.GJ26275@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203090304.GJ26275@8bytes.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 10:03:04AM +0100, Joerg Roedel wrote:

> > > > Have you tried porting any of the current iommu controllers to
> > > > this new framework to see if it works properly for them?
> > > 
> > > It works currently for VT-d. I also port it to AMD IOMMU
> > > currently. With some extensions (offset for start address, flags
> > > and size limitation) it is also suitable for IOMMUs like GART or
> > > similar ones.
> > 
> > What about the Calgary chipset?
> 
> Calgary is quite similar to GART (there is something like the
> aperture and a linear single-level pagetable).

Actually, Calgary has multiple per-bus address spaces (each of which
is a single-level linear pagetable limited to 4GB of addressable
memory), so I think it should work with your current approach pretty
much as is, once we take into account these two (per-bus and 32-bit
addressability) limitations.

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                       <->
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
