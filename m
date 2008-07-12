Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYGLDre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYGLDre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 23:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYGLDrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 23:47:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:46620 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYGLDrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 23:47:24 -0400
Subject: Re: [PATCH] PCI: Add support for multiple MSI
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, grundler@parisc-linux.org, mingo@elte.hu,
       tglx@linutronix.de, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       suresh.b.siddha@intel.com, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <willy@linux.intel.com>
In-Reply-To: <487719AC.9070609@jp.fujitsu.com>
References: <20080711005719.GO14894@parisc-linux.org>
	 <1215738002-4961-2-git-send-email-matthew@wil.cx>
	 <487719AC.9070609@jp.fujitsu.com>
Content-Type: text/plain
Date: Sat, 12 Jul 2008 13:45:42 +1000
Message-Id: <1215834342.7549.151.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 17:28 +0900, Hidetoshi Seto wrote:
> Hi,
> 
> First of all, it seems that mask/unmask of MSI has problems.
>  - Per-vector masking is optional for MSI, so I think that allocating
>    multiple messages for a function without masking capability would be
>    not good idea, since all vector in the block will be masked/unmasked
>    at once without any agreement.
>  - Even if the function supports per-vector masking, current
>    mask/unmask_msi_irq() functions assume that MSI uses only one vector,
>    therefore they only set/unset the first bit of the maskbits which
>    for the first vector of the block.  The bits for other vectors are
>    initialized as 'masked' but no one unmask them.

I tend to think we should just do soft-masking anyway for MSI... better
than whacking config space.

Ben

