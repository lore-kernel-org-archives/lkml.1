Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYI1Sth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYI1Sth (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 14:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbYI1St2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 14:49:28 -0400
Received: from 8bytes.org ([88.198.83.132]:44408 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYI1St2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 14:49:28 -0400
Date: Sun, 28 Sep 2008 20:49:26 +0200
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, muli@il.ibm.com,
       amit.shah@qumranet.com, mingo@redhat.com
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
Message-ID: <20080928184926.GB26563@8bytes.org>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <20080928232129J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080928232129J.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 11:21:26PM +0900, FUJITA Tomonori wrote:
> On Mon, 22 Sep 2008 20:21:12 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > Hi,
> > 
> > this patch series implements stackable dma_ops on x86. This is useful to
> > be able to fall back to a different dma_ops implementation if one can
> > not handle a particular device (as necessary for example with
> > paravirtualized device passthrough or if a hardware IOMMU only handles a
> > subset of available devices).
> 
> We already handle the latter. This patchset is more flexible but
> seems to incur more overheads.
> 
> This feature will be used for only paravirtualized device passthrough?
> If so, I feel that there is more simpler (and specific) solutions for
> it.

Its not only for device passthrough. It handles also the cases where a
hardware IOMMU does not handle all devices in the system (like in some
Calgary systems but also possible with AMD IOMMU). With this patchset we
can handle these cases in a generic way without hacking it into the
hardware drivers (these hacks are also in the AMD IOMMU code and I plan
to remove them in the case this patchset will be accepted).

Joerg

