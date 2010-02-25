Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0BYNHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:07:04 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:26263 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab0BYNHB (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 25 Feb 2010 08:07:01 -0500
Date: Thu, 25 Feb 2010 07:49:17 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH 02/10] swiotlb: Make 'setup_io_tlb_npages' accept new
	'swiotlb=' syntax.
Message-ID: <20100225124917.GB9040@phenom.dumpdata.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com> <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com> <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com> <20100225155242F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225155242F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B8675CF.002B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 03:53:20PM +0900, FUJITA Tomonori wrote:
> On Thu, 18 Feb 2010 11:26:58 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > The old syntax for 'swiotlb' is still in effect, and we extend it
> > now to include the overflow buffer size. The syntax is now:
> > 
> > swiotlb=[force,][nslabs=<pages>,][overflow=<size>] or more
> > commonly know as:
> > 
> > swiotlb=[force]
> > swiotlb=[nslabs=<pages>]
> > swiotlb=[overflow=<size>]
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  Documentation/x86/x86_64/boot-options.txt |    6 ++++-
> >  lib/swiotlb.c                             |   36 +++++++++++++++++++++++++---
> >  2 files changed, 37 insertions(+), 5 deletions(-)
> 
> 'overflow' is a workaround for broken drivers (that ignores DMA
> mapping errors). We have fixed such drivers and other hardware IOMMU
> implementations don't have such workaround. So please don't extend
> it. We should remove it instead.

Will do. Do you remember which drivers (or e-mail threads) exhibited this
behavior so that I can do a regression test to make absolutely certain
that removing the overflow functionality won't blow something up?

