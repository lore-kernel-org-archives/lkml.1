Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbZFLPvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbZFLPvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZFLPvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:51:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:6182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbZFLPvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,210,1243839600"; 
   d="scan'208";a="153611388"
Date: Fri, 12 Jun 2009 08:50:53 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "general@lists.openfabrics.org" <general@lists.openfabrics.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mthca double free irqs
Message-ID: <20090612085053.0fbe9731@jbarnes-g45>
In-Reply-To: <adafxe51pz9.fsf@cisco.com>
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	<adafxe51pz9.fsf@cisco.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 07:33:30 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> By the way, can you try this with the ib_mthca module option
> "msi_x=0" -- because I see
> 
>  > [  606.538429] ib_mthca 0000:c4:00.0: NOP command failed to
>  > generate interrupt (IRQ 234).
>  > [  606.543348] ib_mthca 0000:c4:00.0: Trying again with MSI-X
>  > disabled.
> 
> But perhaps the fallback to non-MSI-X in the driver is messing things
> up.  Also you have:

My linux-next branch has a change to the return value from the MSI-X
allocation function: pci_enable_msix now returns the number of
available entries rather than -EINVAL if the allocation failed.  Would
that cause problems in the mthca driver?

-- 
Jesse Barnes, Intel Open Source Technology Center
