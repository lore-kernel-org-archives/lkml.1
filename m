Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZEUKtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZEUKtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZEUKs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:48:57 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:7218 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752394AbZEUKs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:48:56 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       gregkh@suse.de, okir@suse.de, beckyb@kernel.crashing.org
In-Reply-To: <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
References: <20090520002955R.fujita.tomonori@lab.ntt.co.jp>
	 <1242748597.22654.44.camel@zakaz.uk.xensource.com>
	 <4A143885.1050502@goop.org> <20090521175436L.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Thu, 21 May 2009 11:48:33 +0100
Message-Id: <1242902913.22654.146.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: Where do we stand with the Xen patches?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=GMTY6ZCfsGoA:10 a=UU1a1liyotcA:10 a=HjBJcK4-zGQEbPWolUIA:9 a=-JSvswhp7Lz6MhjmDmAA:7 a=TwTkOdF72b4i4ubybAgAtnjL1qkA:4 a=pWx0zAGHE-iyrk3q:21 a=gqRVyCXEPZ6T9mfE:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 17:54 +0900, FUJITA Tomonori wrote:
> @@ -819,8 +796,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
>                 phys_addr_t paddr = sg_phys(sg);
>                 dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
>  
> -               if (range_needs_mapping(paddr, sg->length) ||
> -                   address_needs_mapping(hwdev, dev_addr, sg->length)) {
> +               if (!is_buffer_dma_capable(hwdev, dma_get_mask(hwdev), paddr, sg->length) ||
> +                   swiotlb_force) {
>                         void *map = map_single(hwdev, sg_phys(sg),
>                                                sg->length, dir);
>                         if (!map) {

BTW I think there was a typo here, dev_addr becomes paddr. I fixed that
in my updated version.

Ian.
-- 
Ian Campbell
Current Noise: Isis - In Fiction

Poorochrondria:
	Hypochrondria derived from not having medical insurance.
		-- Douglas Coupland, "Generation X: Tales for an Accelerated
		   Culture"

