Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYGTJnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYGTJnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 05:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYGTJnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 05:43:17 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:7987 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbYGTJnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 05:43:15 -0400
Date: Sun, 20 Jul 2008 12:42:39 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chandru <chandru@in.ibm.com>, linux-kernel@vger.kernel.org,
       alexisb@us.ibm.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [RFC] [Patch] calgary iommu: Use the first kernel's tce tables
	in kdump
Message-ID: <20080720094239.GE7173@il.ibm.com>
References: <1191962414.24134.68.camel@chandru> <200806211741.43703.chandru@in.ibm.com> <20080623192918.GB6989@il.ibm.com> <200807151415.27845.chandru@in.ibm.com> <20080717161414.c5a267f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717161414.c5a267f7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 04:14:14PM -0700, Andrew Morton wrote:
> On Tue, 15 Jul 2008 14:15:27 +0530
> Chandru <chandru@in.ibm.com> wrote:
> 
> > kdump kernel fails to boot with calgary iommu and aacraid driver on a x366 
> > box. The ongoing dma's of aacraid from the first kernel continue to exist 
> > until the driver is loaded in the kdump kernel. Calgary is initialized prior 
> > to aacraid and creation of new tce tables causes wrong dma's to occur. Here 
> > we try to get the tce tables of the first kernel in kdump kernel and use 
> > them. While in the kdump kernel we do not allocate new tce tables but instead 
> > read the base addres register contents of calgary iommu and use the tables 
> > that the registers point to. With these changes the kdump kernel and hence 
> > aacraid now boots normally.
> > 
> > Signed-off-by: Chandru Siddalingappa <chandru@in.ibm.com>
> > ---
> > 
> > patch taken on top of linux-2.6.26 stable. Comments from Muli Ben-Yehuda taken 
> > into consideration. Pls apply it as a stop-gap patch until we can come up 
> > with a more stable patch for this issue. Thanks,
> 
> Is this needed in 2.6.26?

No, it's 2.6.27 material.

Cheers,
Muli
