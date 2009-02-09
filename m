Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZBIVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZBIVu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZBIVuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:50:14 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:24685 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZBIVuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:50:12 -0500
Message-ID: <4990A51C.1090607@oracle.com>
Date: Mon, 09 Feb 2009 13:50:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: linux-next: Tree for February 9 (ide-dma)
References: <20090209193908.1a448944.sfr@canb.auug.org.au> <499064CC.1030907@oracle.com> <200902091956.54226.bzolnier@gmail.com>
In-Reply-To: <200902091956.54226.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4990A50A.012C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Monday 09 February 2009, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> [I accidentally deleted the merge and quilt-import logs today :-( - I
>>> wonder if any would have noticed :-).  The merge summary still appears
>>> below.]
>>>
>>> Changes since 20090206:
>>>
>>> New tree:
>>> 	aoe
>>>
>>> Undropped trees:
>>> 	ide
>>
>> When CONFIG_BLK_DEV_IDEDMA=n:
>>
>> drivers/ide/ide-taskfile.c:104: error: implicit declaration of function 'ide_build_sglist'
> 
> Thanks.  Should be fixed with new revision of the guilty patch
> (fix part is in <linux/ide.h> chunk):

Ack.  That works.  Thanks.

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: call ide_build_sglist() prior to ->dma_setup (v2)
> 
> * Re-map sg table if needed in ide_build_sglist().
> 
> * Move ide_build_sglist() call from ->dma_setup to its users.
> 
> * Un-export ide_build_sglist().
> 
> v2:
> * Build fix for CONFIG_BLK_DEV_IDEDMA=n (noticed by Randy Dunlap).
> 
> There should be no functional changes caused by this patch.
> 
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1474,6 +1474,8 @@ static inline int ide_set_dma(ide_drive_
>  static inline void ide_check_dma_crc(ide_drive_t *drive) { ; }
>  static inline ide_startstop_t ide_dma_timeout_retry(ide_drive_t *drive, int error) { return ide_stopped; }
>  static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
> +static inline int ide_build_sglist(ide_drive_t *drive,
> +				   struct request *rq) { return 0; }
>  #endif /* CONFIG_BLK_DEV_IDEDMA */
>  
>  #ifdef CONFIG_BLK_DEV_IDEACPI
> 
> 
> 
> 


-- 
~Randy
