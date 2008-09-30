Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYI3NbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYI3NbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYI3NbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:31:09 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:53811 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbYI3NbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:31:06 -0400
Date: Tue, 30 Sep 2008 16:30:24 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>,
       Amit Shah <amit.shah@qumranet.com>, Ingo Molnar <mingo@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/9] x86/iommu: change Calgary to use dma_ops register
	interface
Message-ID: <20080930133024.GA20341@il.ibm.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-7-git-send-email-joerg.roedel@amd.com> <20080930111028.GC12529@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930111028.GC12529@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 01:10:28PM +0200, Ingo Molnar wrote:
> 
> * Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > +static int calgary_device_supported(struct device *dev)
> > +{
> > +	struct iommu_table *tbl;
> > +
> > +	tbl = find_iommu_table(dev);
> > +
> > +	return translation_enabled(tbl);
> > +}
> 
> i guess this could be written as a simple:
> 
> > +static int calgary_device_supported(struct device *dev)
> > +{
> > +	return translation_enabled(find_iommu_table(dev));
> > +}

Sure, but I prefer the explicit form since it lends itself to easier
debugging (oops line numbers, adding printks, etc.).

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                      xxx
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
