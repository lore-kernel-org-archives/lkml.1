Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYI2N1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYI2N1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYI2N1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:27:08 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:47963 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbYI2N1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:27:07 -0400
X-BigFish: VPS-23(zz1432R98dR1805M936fO873fnzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7YLCM-04-A6A-01
Date: Mon, 29 Sep 2008 15:26:47 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org, muli@il.ibm.com,
       amit.shah@qumranet.com, mingo@redhat.com
Subject: Re: [PATCH 0/9][RFC] stackable dma_ops for x86
Message-ID: <20080929132647.GJ27928@amd.com>
References: <1222107681-8185-1-git-send-email-joerg.roedel@amd.com> <20080928232129J.fujita.tomonori@lab.ntt.co.jp> <20080928184926.GB26563@8bytes.org> <20080929221354T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080929221354T.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 29 Sep 2008 13:26:48.0275 (UTC) FILETIME=[06675230:01C92237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 10:16:39PM +0900, FUJITA Tomonori wrote:
> On Sun, 28 Sep 2008 20:49:26 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
> 
> > On Sun, Sep 28, 2008 at 11:21:26PM +0900, FUJITA Tomonori wrote:
> > > On Mon, 22 Sep 2008 20:21:12 +0200
> > > Joerg Roedel <joerg.roedel@amd.com> wrote:
> > > 
> > > > Hi,
> > > > 
> > > > this patch series implements stackable dma_ops on x86. This is useful to
> > > > be able to fall back to a different dma_ops implementation if one can
> > > > not handle a particular device (as necessary for example with
> > > > paravirtualized device passthrough or if a hardware IOMMU only handles a
> > > > subset of available devices).
> > > 
> > > We already handle the latter. This patchset is more flexible but
> > > seems to incur more overheads.
> > > 
> > > This feature will be used for only paravirtualized device passthrough?
> > > If so, I feel that there is more simpler (and specific) solutions for
> > > it.
> > 
> > Its not only for device passthrough. It handles also the cases where a
> > hardware IOMMU does not handle all devices in the system (like in some
> > Calgary systems but also possible with AMD IOMMU). With this patchset we
> 
> I know that. As I wrote in the previous mail, we already solved that
> problem with per-device-dma-ops.
> 
> My question is what unsolved problems this patchset can fix?
> 
> 
> This patchset is named "stackable dma_ops" but it's different from
> what we discussed as "stackable dma_ops". This patchset provides
> IOMMUs a generic mechanism to set up "stackable dma_ops". But this
> patchset doesn't solve the problem that a hardware IOMMU does not
> handle all devices (it was already solved with per-device-dma-ops).
> 
> If paravirtualized device passthrough still needs to call multiple
> dma_ops, then this patchset doesn't solve that issue.

Ok, the name "stackable" is misleading and was a bad choice. I will
rename it to "multiplexing". This should make it more clear what it is.
Like you pointed out, the problems are solved with per-device dma_ops,
but in the current implementation it needs special hacks in the IOMMU
drivers to use these per-device dma_ops.
I see this patchset as a continuation of the per-device dma_ops idea. It
moves the per-device handling out of the specific drivers to a common
place. So we can avoid or remove special hacks in the IOMMU drivers.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

