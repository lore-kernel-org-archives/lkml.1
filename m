Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYEOJoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYEOJoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYEOJoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:44:34 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:51328 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbYEOJoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:44:34 -0400
Date: Thu, 15 May 2008 18:41:26 +0900
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, muli@il.ibm.com, alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <482C02A4.80101@firstfloor.org>
References: <87y76cym96.fsf@basil.nowhere.org>
	<20080515181619R.tomof@acm.org>
	<482C02A4.80101@firstfloor.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080515184126O.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 11:30:12 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 15 May 2008 11:01:09 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> >> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> >>
> >>> This patchset adds per-device dma_mapping_ops support for
> >>> CONFIG_X86_64 like POWER architecture does. This change enables us to
> >>> cleanly fix the Calgary IOMMU issue that some devices are not behind
> >>> the IOMMU [1]. It also would be helpful to handle KVM PCI passthrough.
> >> This makes it basically impossible to do stack ops, which some 
> >> people have been doing.
> > 
> > Seems that I misunderstand what those people want.
> > 
> > What those people want to do and how the stack ops achieve it? Or can
> > you tell me where their patches are?
> 
> I've seen it in two cases: first was for KVM IO bypass and the other was a 
> (unfinished) patch to support the NoDMA bitmaps on some systems.
> 
> In this case you really want to do a wrapper around the existing ops
> and extend the mapping. 
> 
> That worked fine by just replacing the global pointer, but will
> be quite hard in your set up.

Thanks,

I thought that KVM people want to do it per device (in the first
case). So with my patchse, they can replace the dma_ops pointer in
dev_archdata with what they want.
