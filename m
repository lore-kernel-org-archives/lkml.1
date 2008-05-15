Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYEOBMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYEOBMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYEOBMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:12:47 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:34889 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYEOBMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:12:47 -0400
Date: Thu, 15 May 2008 10:12:25 +0900
To: muli@il.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080514054924.GD6682@il.ibm.com>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080514054924.GD6682@il.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080515101212Z.tomof@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 08:49:24 +0300
Muli Ben-Yehuda <muli@il.ibm.com> wrote:

> On Tue, May 13, 2008 at 03:04:50PM +0900, FUJITA Tomonori wrote:
> 
> > This patchset adds per-device dma_mapping_ops support for
> > CONFIG_X86_64 like POWER architecture does. This change enables us
> > to cleanly fix the Calgary IOMMU issue that some devices are not
> > behind the IOMMU [1]. It also would be helpful to handle KVM PCI
> > passthrough.
> 
> Awesome! Much needed, thank you for doing this.

No problem. Well, as you know, it's just a base. We need more work to
solve the problems on the top of this.

I'd like to have a mechanism to register a hook called when a new pci
(or dma capable) device is created. It enables IOMMUs to set up an
appropriate dma_mapping_ops per device. It could also enables us to
simplify the IOMMUs code to initilize devices at startup (for exmple,
intel-iommu checks all the pci devices and creates a domain per device
if necessary).

I'll post an updated version against -mm. If people seems to be fine
with per-device dma_mapping_ops, then I'll work on further issues.
