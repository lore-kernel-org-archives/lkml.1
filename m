Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbYF0Rb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbYF0Rb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbYF0Rbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:31:46 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:27879 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbYF0Rbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:31:46 -0400
Date: Fri, 27 Jun 2008 13:31:00 -0400
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andi Kleen <andi@firstfloor.org>, Adrian Bunk <bunk@kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, tglx@linutronix.de,
       mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com,
       Ben-Ami Yassour1 <benami@il.ibm.com>
Subject: Re: [PATCH 01/34] AMD IOMMU: add Kconfig entry
Message-ID: <20080627173100.GD26130@il.ibm.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-2-git-send-email-joerg.roedel@amd.com> <20080627142558.GG18644@cs181140183.pp.htv.fi> <878wwrq6im.fsf@basil.nowhere.org> <20080627163945.GA26130@il.ibm.com> <20080627165430.GD10197@8bytes.org> <20080627165947.GB26130@il.ibm.com> <20080627170546.GE10197@8bytes.org> <20080627171201.GC26130@il.ibm.com> <20080627172030.GF10197@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627172030.GF10197@8bytes.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 07:20:30PM +0200, Joerg Roedel wrote:

> > Could you elaborate on what you mean here? I assume you're
> > thinking one I/O address space for the host, and one I/O address
> > space per guest with assigned devices?
> 
> I think we can create an address space which almost direct-maps the
> physical memory and let some room free for the aperture at the
> beginning (say 64MB). If a mapping request arrives the code looks if
> it has to do mapping (physical address of memory to map is in the
> first 64MB or not in the device address range). If this is not the
> case it simply returns the physical address as dma_addr. otherwise
> it does the expensive mapping. This way we could minimize the
> default overhead which we will get with an IOMMU and still use it
> for virtualization and as a GART replacement.

What you are suggesting is an "almost-direct-map" approach for the
host I/O address space, which provides no protection from mis-behaving
host drivers. If we could avoid needing a GART replacement (see below
for why I think we could), you could simply avoid enabling translation
for host devices and be done with it.

In my humble opinion it's more interesting to try and figure out how
to get protection from mis-behaving host drivers while still keeping
performance as close as possible to native.

> > > and to handle devices with limited DMA address ranges.
> > 
> > I'd be pretty surprised if you'll find such devices on machines which
> > will have AMD's IOMMU...
> 
> Think of 32bit PCI devices in a host with more than 4GB memory :)

I am thinking of them and I'd be surprised if you'd find any in such
machines. Certainly I assume none of the on-board devices will have
this ancient limitation. But hey, it could happen ;-)

Cheers,
Muli
