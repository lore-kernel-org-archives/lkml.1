Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYGJNKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYGJNKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 09:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbYGJNK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 09:10:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754174AbYGJNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 09:10:26 -0400
Date: Thu, 10 Jul 2008 06:03:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 14/34] AMD IOMMU: clue initialization code together
Message-Id: <20080710060351.770992cc.akpm@linux-foundation.org>
In-Reply-To: <20080710123747.GK14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-15-git-send-email-joerg.roedel@amd.com>
	<20080709185512.6355159c.akpm@linux-foundation.org>
	<20080710123747.GK14977@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 14:37:47 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> > Is there a reason for using __get_free_pages() in this manner everywhere? 
> > kmalloc() or kzalloc() are unsuitable?
> 
> Yes. The device table has to be page aligned and has a maximum size of
> 2 MB. 

OK

> > > +	if (amd_iommu_dev_table == NULL)
> > > +		goto out;
> > > +
> > > +	/*
> > > +	 * Alias table - map PCI Bus/Dev/Func to Bus/Dev/Func the
> > > +	 * IOMMU see for that device
> > > +	 */
> > > +	amd_iommu_alias_table = (void *)__get_free_pages(GFP_KERNEL,
> > > +			get_order(alias_table_size));
> 
> Hmm, maybe this table will fit into a kmalloc allocation. Its maximum
> size is 128 kb.

Might as well keep it all consistent in that case.

