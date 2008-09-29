Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbYI2NTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbYI2NTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYI2NTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:19:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:51869 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbYI2NTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:19:06 -0400
Date: Mon, 29 Sep 2008 22:16:39 +0900
To: joro@8bytes.org
Cc: fujita.tomonori@lab.ntt.co.jp, joerg.roedel@amd.com,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, muli@il.ibm.com,
       amit.shah@qumranet.com, mingo@redhat.com
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080928184926.GB26563@8bytes.org>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com>
	<20080928232129J.fujita.tomonori@lab.ntt.co.jp>
	<20080928184926.GB26563@8bytes.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080929221354T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Sep 2008 20:49:26 +0200
Joerg Roedel <joro@8bytes.org> wrote:

> On Sun, Sep 28, 2008 at 11:21:26PM +0900, FUJITA Tomonori wrote:
> > On Mon, 22 Sep 2008 20:21:12 +0200
> > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > 
> > > Hi,
> > > 
> > > this patch series implements stackable dma_ops on x86. This is useful to
> > > be able to fall back to a different dma_ops implementation if one can
> > > not handle a particular device (as necessary for example with
> > > paravirtualized device passthrough or if a hardware IOMMU only handles a
> > > subset of available devices).
> > 
> > We already handle the latter. This patchset is more flexible but
> > seems to incur more overheads.
> > 
> > This feature will be used for only paravirtualized device passthrough?
> > If so, I feel that there is more simpler (and specific) solutions for
> > it.
> 
> Its not only for device passthrough. It handles also the cases where a
> hardware IOMMU does not handle all devices in the system (like in some
> Calgary systems but also possible with AMD IOMMU). With this patchset we

I know that. As I wrote in the previous mail, we already solved that
problem with per-device-dma-ops.

My question is what unsolved problems this patchset can fix?


This patchset is named "stackable dma_ops" but it's different from
what we discussed as "stackable dma_ops". This patchset provides
IOMMUs a generic mechanism to set up "stackable dma_ops". But this
patchset doesn't solve the problem that a hardware IOMMU does not
handle all devices (it was already solved with per-device-dma-ops).

If paravirtualized device passthrough still needs to call multiple
dma_ops, then this patchset doesn't solve that issue.


> can handle these cases in a generic way without hacking it into the
> hardware drivers (these hacks are also in the AMD IOMMU code and I plan
> to remove them in the case this patchset will be accepted).
