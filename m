Return-Path: <linux-kernel-owner+w=401wt.eu-S1754096AbZFEMof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbZFEMof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 08:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZFEMoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 08:44:25 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:10748
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751345AbZFEMoY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 08:44:24 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zz1418M1432R98dR1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KKRNDN-04-35T-01
Date: Fri, 5 Jun 2009 14:44:12 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: torvalds@linux-foundation.org, mingo@elte.hu, lethal@linux-sh.org,
       just.for.lkml@googlemail.com, hancockrwd@gmail.com,
       jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Message-ID: <20090605124412.GF24836@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 Jun 2009 12:44:12.0783 (UTC) FILETIME=[5411EFF0:01C9E5DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:38:22PM +0900, FUJITA Tomonori wrote:
> On Fri, 5 Jun 2009 12:41:33 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:

> I thought about something like this fix however we can do better; with
> this fix, we could overlook a bad hardware IOMMU bug.

I don't buy this yet. Can you explain what kind of hardware IOMMU bug we
can miss here? For the match in my patch it is still strictly necessary
that the dma address matches.

> I think that the better fix can handle both cases per device:
> 
> - multiple identical dma addresses should not happen (with devices
>   behind hardware IOMMU)
> - multiple identical dma addresses could happen
> 
> 
> It's better to use a strict-fit algorithm (as we do now) with the
> former. It's pretty difficult to do something better than a best-fit
> algorithm with the latter though.

When we understand the same under 'strict-fit' this will not work I
think. The idea behind dma-debug is to find the cases where the
dma_unmap parameters are not equal to the dma_map parameters. If we use
strict-fit we risk to oversee some sets of these cases because there is
no dma_debug_entry which strictly matches the reference value.

Regards,

Joerg


-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

