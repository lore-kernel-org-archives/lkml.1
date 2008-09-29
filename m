Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYI2J0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYI2J0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYI2J0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:26:34 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:39302 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbYI2J0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:26:31 -0400
Date: Mon, 29 Sep 2008 12:25:49 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       amit.shah@qumranet.com, mingo@redhat.com
Subject: Re: [PATCH 9/9] x86/iommu: use dma_ops_list in get_dma_ops
Message-ID: <20080929092549.GA6931@il.ibm.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <1222107681-8185-10-git-send-email-joerg.roedel@amd.com> <20080928231211X.fujita.tomonori@lab.ntt.co.jp> <20080928184424.GA26563@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928184424.GA26563@8bytes.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 08:44:24PM +0200, Joerg Roedel wrote:

> Hmm, we should only call find_dma_ops_for_device() the first time a
> dma api call is done (look into get_dma_ops). But I also thought
> about how this lock can be avoided. In the real world it should not
> be necessary because the dma_ops list is initialized before dma api
> calls are done. But since there is now a register function which can
> be called its safer this way. What do you think, are we still safe
> enough without this lock?

We could be, if we add a check to the register function that verifies
it isn't being called after DMAs have started. Something like:

in register:

  if (dma_started)
    yell loudly

before PCI device initialization and after IOMMU initialization:
  dma_started = true

Cheers,
Muli
-- 
The First Workshop on I/O Virtualization (WIOV '08)
Dec 2008, San Diego, CA, http://www.usenix.org/wiov08/
                      xxx
SYSTOR 2009---The Israeli Experimental Systems Conference
http://www.haifa.il.ibm.com/conferences/systor2009/
