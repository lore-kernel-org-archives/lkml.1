Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbYJLHRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbYJLHRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 03:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYJLHRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 03:17:03 -0400
Received: from colo.lackof.org ([198.49.126.79]:34807 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbYJLHRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 03:17:01 -0400
Date: Sun, 12 Oct 2008 01:16:49 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: yinghai@kernel.org, grundler@parisc-linux.org, matthew@wil.cx,
       jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: print out DMA mask info
Message-ID: <20081012071649.GB20056@colo.lackof.org>
References: <86802c440810092156i18bb7699vb8e90d52accad781@mail.gmail.com> <20081010150815B.fujita.tomonori@lab.ntt.co.jp> <48EEF713.6050502@kernel.org> <20081010163145W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010163145W.fujita.tomonori@lab.ntt.co.jp>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 04:32:07PM +0900, FUJITA Tomonori wrote:
...
> > > Well, that's because I wrote gart's alloc_coherent and introduced
> > > dma_alloc_coherent_mask. ;)
> > 
> > oh. it is in tip
> 
> Yeah, it's in tip. But the current gart code uses coherent_dma_mask
> properly (GART in tip works in the same way as the current
> GART). IIRC, other X86 hardware IOMMUs (VT-d, Calgary, AMD) uses
> dma_mask in dma_alloc_coherent (AMD in tip uses coherent_dma_mask).

This is a bug. Care to submit a patch to fix it?
I don't have any of the docs or HW (VT-d, Calgary) to test it.


> > then can we remove consistent_dma_mask? just use dma_mask instead for all.
> 
> I don't think we can. One architecture needs it. The above usb
> chip seems to need it.

As noted before, several PCI-X devices support 64-bit DMA for payload
data but only 32-bit DMA for control data.

thanks,
grant
