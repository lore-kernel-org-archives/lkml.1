Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbZFLHvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbZFLHvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZFLHvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:51:04 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17423
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbZFLHvD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:51:03 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz98dRzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KL48GT-03-7MS-01
Date: Fri, 12 Jun 2009 09:50:50 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu,
       lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com,
       bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Message-ID: <20090612075050.GW5139@amd.com>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com> <20090611081032.GN5139@amd.com> <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 12 Jun 2009 07:50:50.0866 (UTC) FILETIME=[8166CD20:01C9EB32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
> I tried this patch, but I still get a wrong warning from the DMA-API:
> Jun 11 19:24:57 treogen [    9.451064] raid1: raid set md2 active with
> 2 out of 2 mirrors
> Jun 11 19:24:57 treogen [    9.479278] md2: bitmap initialized from
> disk: read 10/10 pages, set 0 bits
> Jun 11 19:24:57 treogen [    9.479282] created bitmap (153 pages) for device md2
> Jun 11 19:24:57 treogen [    9.513544] md: ... autorun DONE.
> Jun 11 19:24:57 treogen [    9.517590]  md3: unknown partition table
> Jun 11 19:24:57 treogen [   20.718608] XFS mounting filesystem dm-0
> Jun 11 19:24:57 treogen [   21.220452] ------------[ cut here ]------------
> Jun 11 19:24:57 treogen [   21.220477] WARNING: at lib/dma-debug.c:532
> check_unmap+0x49e/0x620()
> Jun 11 19:24:57 treogen [   21.220482] Hardware name: KFN5-D SLI
> Jun 11 19:24:57 treogen [   21.220488] sata_sil24 0000:04:00.0:
> DMA-API: device driver tries to free DM A memory it has not allocated [device address=0x000000011e4c3000]

This happens with the best-fit if there is no perfect fit but multiple
matches. This warning needs to be adjusted to also cover this case. I
have this on my list and will fix it soon.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

