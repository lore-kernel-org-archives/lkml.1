Return-Path: <linux-kernel-owner+w=401wt.eu-S1753781AbYHHQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbYHHQQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbYHHQQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:16:08 -0400
Received: from outbound-mail-18.bluehost.com ([69.89.20.233]:59376 "HELO
	outbound-mail-18.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752564AbYHHQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:16:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=Jc8Q/iyi9rd8cRZiahl+hChTZpDdRb6g7tg5MK+68dX/+sAjLIndIpDMn2Go/DsNZOA01txO+J+2YA/OZhBuTmH42cLgP+8imxiY7K8ukRM4tThYs7uFUrw3BcHDyEcn;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
Date: Fri, 8 Aug 2008 09:15:51 -0700
User-Agent: KMail/1.9.9
Cc: Muli Ben-Yehuda <muli@il.ibm.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jakub@redhat.com
References: <200807281523.35469.jbarnes@virtuousgeek.org> <20080808071244.GB6931@il.ibm.com> <489C63D1.1000407@redhat.com>
In-Reply-To: <489C63D1.1000407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808080915.52459.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 8, 2008 8:18 am Prarit Bhargava wrote:
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -78,7 +78,7 @@ static inline unsigned int dma_set_max_seg_size(struct
> device
>  static inline unsigned long dma_get_seg_boundary(struct device *dev)
>  {
>         return dev->dma_parms ?
> -               dev->dma_parms->segment_boundary_mask : 0xffffffff;
> +               dev->dma_parms->segment_boundary_mask : 0xffffffffUL;
>  }

Yeah generally you need to cast values like this when working with real 
unsigned long values rather than ints, but this *should* still be safe 
(barring a compiler bug).  The return type is unsigned long, so even if you 
just return 0xffffffff the right thing should still happen...

Jesse
