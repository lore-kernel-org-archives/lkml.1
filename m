Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035Ab0AFRsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab0AFRsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024Ab0AFRs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:48:29 -0500
Received: from daytona.panasas.com ([67.152.220.89]:10027 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756021Ab0AFRs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:48:27 -0500
Message-ID: <4B44CCE7.9060103@panasas.com>
Date: Wed, 06 Jan 2010 19:48:23 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.33-rc3
References: <1262797332.2946.147.camel@mulgrave.site>
In-Reply-To: <1262797332.2946.147.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2010 17:48:25.0657 (UTC) FILETIME=[7271BA90:01CA8EF8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 07:02 PM, James Bottomley wrote:
> This patch represents the accumulated bug fixes in a variety of drivers,
> with concentrated bug fix updates for emulex NPIV and qla2xxx EEH.
> 

James you have missed a very serious fix to scsi_lib.
  http://www.spinics.net/lists/linux-scsi/msg41125.html

In Fedora12, if there is an iscsi device in the system, as a normal user
I can run a cooked up, push bidi commands via bsg program that can easily
crash the Kernel. It must be plugged. (Regardless if the target is not
bidi the command can error, it does not matter)

The fix itself is a one liner no brainer. Just use before you free.

Also needed by stable

Cheers
Boaz

> The patch is available at:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> The short changelog is
> 
> Andrew Vasquez (1):
>       qla2xxx: Extend base EEH support in qla2xxx.
> 
> Anil Ravindranath (1):
>       pmcraid: fix to avoid twice scsi_dma_unmap for a command
> 
> Anirban Chakraborty (1):
>       qla2xxx: Fix for a multiqueue bug in CPU affinity mode
> 
> Duane Grigsby (1):
>       qla2xxx: Added to EEH support.
> 
> Ed Lin (1):
>       stex: fix scan of nonexistent lun
> 
> Giridhar Malavali (1):
>       qla2xxx: Update version number to 8.03.01-k9.
> 
> James Smart (6):
>       lpfc 8.3.7: Update Driver version to 8.3.7
>       lpfc 8.3.7: Fix discovery failures.
>       lpfc 8.3.7: Fix SCSI protocol related errors.
>       lpfc 8.3.7: Fix hardware/SLI relates issues
>       lpfc 8.3.7: Fix NPIV operation errors
>       lpfc 8.3.7: Fix FC protocol errors
> 
> Michael Hernandez (1):
>       qla2xxx: Get the link data rate explicitly during device resync.
> 
> Rakesh Ranjan (1):
>       cxgb3i: Fix a login over vlan issue
> 
> the diffstat
> 
>  drivers/scsi/cxgb3i/cxgb3i_offload.c |   34 ++++++++++++-
>  drivers/scsi/lpfc/lpfc_els.c         |    4 -
>  drivers/scsi/lpfc/lpfc_hbadisc.c     |   25 ++++++++-
>  drivers/scsi/lpfc/lpfc_hw4.h         |    3 -
>  drivers/scsi/lpfc/lpfc_init.c        |   14 ++++-
>  drivers/scsi/lpfc/lpfc_sli.c         |   48 +++++++++++-------
>  drivers/scsi/lpfc/lpfc_sli4.h        |    2 
>  drivers/scsi/lpfc/lpfc_version.h     |    2 
>  drivers/scsi/lpfc/lpfc_vport.c       |    4 +
>  drivers/scsi/pmcraid.c               |    8 +--
>  drivers/scsi/qla2xxx/qla_attr.c      |   32 ++++++++++--
>  drivers/scsi/qla2xxx/qla_dbg.h       |    9 +++
>  drivers/scsi/qla2xxx/qla_def.h       |    2 
>  drivers/scsi/qla2xxx/qla_gbl.h       |    1 
>  drivers/scsi/qla2xxx/qla_init.c      |   22 ++++++++
>  drivers/scsi/qla2xxx/qla_isr.c       |    9 ++-
>  drivers/scsi/qla2xxx/qla_mbx.c       |   64 +++++++++++++++++++++++-
>  drivers/scsi/qla2xxx/qla_mid.c       |    2 
>  drivers/scsi/qla2xxx/qla_os.c        |   90 +++++++++++++++++++++++++++++++----
>  drivers/scsi/qla2xxx/qla_version.h   |    2 
>  drivers/scsi/stex.c                  |    5 +
>  21 files changed, 322 insertions(+), 60 deletions(-)
> 
> Entire diff is below.
> 
> James
> 
<snip>
