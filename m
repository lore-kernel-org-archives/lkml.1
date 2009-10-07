Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbZJGFMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbZJGFMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 01:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZJGFMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 01:12:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZJGFMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 01:12:15 -0400
Date: Wed, 7 Oct 2009 10:40:47 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       David Howells <dhowells@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [Alacrityvm-devel] [PATCH v2 2/4] KVM: introduce "xinterface"
	API for external interaction with guests
Message-ID: <20091007051047.GA24176@amit-x200.redhat.com>
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB6E21.8010109@redhat.com> <4ACB771E.8050404@gmail.com> <20091006181859.GD6386@ovro.caltech.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006181859.GD6386@ovro.caltech.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) Oct 06 2009 [11:18:59], Ira W. Snyder wrote:
> 
> The limitation I have is that memory made available from the host system
> (PCI card) as PCI BAR1 must not be migrated around in memory. I can only
> change the address decoding to hit a specific physical address. AFAIK,
> this means it cannot be userspace memory (since the underlying physical
> page could change, or it could be in swap), and must be allocated with
> something like __get_free_pages() or dma_alloc_coherent().

If the dma area is just one page in size, that page can be pinned by the
host (via a hypercall by the guest). If it's more, there is a
reserve-ram patch by Andrea. That'll reserve some RAM area for the guest
that's 1-1 mapped in the host address space. There was a patch posted on
the list sometime back.

		Amit
