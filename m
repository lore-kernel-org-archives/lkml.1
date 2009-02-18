Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZBRRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZBRRRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZBRRRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:17:00 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:28386 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZBRRQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:16:58 -0500
Message-ID: <499C42A8.7060003@oracle.com>
Date: Wed, 18 Feb 2009 09:17:28 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: linux-next: Tree for February 12 (ide)
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au> <499451E0.6060004@oracle.com> <200902171519.27031.bzolnier@gmail.com>
In-Reply-To: <200902171519.27031.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.499C4279.023F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Thursday 12 February 2009, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20090211:
>>
>> When
>> # CONFIG_BLK_DEV_IDEDMA is not set
>>
>> linux-next-20090212/drivers/ide/ide-taskfile.c:108: error: 'ide_dma_intr' undeclared (first use in this function)
> 
> Thanks for spotting this, I fixed it in the revised patch:

Hi Bart,

Have you pushed this patch yet?

linux-next (20090218) is still getting this IDE build error.

Thanks.

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: add ->dma_timer_expiry method and remove ->dma_exec_cmd one (v2)
> 
> * Rename dma_timer_expiry() to ide_dma_sff_timer_expiry() and export it.
> 
> * Add ->dma_timer_expiry method and use it to set hwif->expiry for
>   ATA_PROT_DMA protocol in do_rw_taskfile().
> 
> * Initialize ->dma_timer_expiry to ide_dma_sff_timer_expiry() for SFF hosts.
> 
> * Move setting hwif->expiry from ide_execute_command() to its users and drop
>   'expiry' argument.
> 
> * Use ide_execute_command() instead of ->dma_exec_cmd in do_rw_taskfile().
> 
> * Remove ->dma_exec_cmd method and its implementations.
> 
> * Unexport ide_execute_command() and ide_dma_intr().
> 
> v2:
> * Fix CONFIG_BLK_DEV_IDEDMA=n build (noticed by Randy Dunlap).
> 
> * Fix *dma_expiry naming (suggested by Sergei Shtylyov).
> 
> There should be no functional changes caused by this patch.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/alim15x3.c     |    2 +-
>  drivers/ide/au1xxx-ide.c   |    8 --------
>  drivers/ide/cmd64x.c       |    6 +++---
>  drivers/ide/cs5536.c       |    2 +-
>  drivers/ide/hpt366.c       |    6 +++---
>  drivers/ide/icside.c       |    7 -------
>  drivers/ide/ide-atapi.c    |    3 ++-
>  drivers/ide/ide-dma-sff.c  |   15 ++++-----------
>  drivers/ide/ide-dma.c      |    1 -
>  drivers/ide/ide-iops.c     |    6 +-----
>  drivers/ide/ide-taskfile.c |    6 ++++--
>  drivers/ide/it821x.c       |    2 +-
>  drivers/ide/ns87415.c      |    2 +-
>  drivers/ide/pdc202xx_old.c |    4 ++--
>  drivers/ide/pmac.c         |    8 --------
>  drivers/ide/sc1200.c       |    2 +-
>  drivers/ide/scc_pata.c     |    2 +-
>  drivers/ide/siimage.c      |    2 +-
>  drivers/ide/sl82c105.c     |    2 +-
>  drivers/ide/tc86c001.c     |    2 +-
>  drivers/ide/trm290.c       |    6 ------
>  drivers/ide/tx4939ide.c    |    2 +-
>  include/linux/ide.h        |    8 ++++----
>  23 files changed, 33 insertions(+), 71 deletions(-)


-- 
~Randy
