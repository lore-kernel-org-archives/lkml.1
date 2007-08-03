Return-Path: <linux-kernel-owner+w=401wt.eu-S932710AbXHCPm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbXHCPm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932285AbXHCPmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:42:43 -0400
Received: from emulex.emulex.com ([138.239.112.1]:47345 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbXHCPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:42:41 -0400
Message-ID: <46B34CCB.4070602@emulex.com>
Date: Fri, 03 Aug 2007 11:42:03 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 44] drivers/scsi/lpfc/lpfc_debugfs.c: kmalloc + memset
 conversion to kcalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312025.45603.m.kozlowski@tuxland.pl>
In-Reply-To: <200707312025.45603.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2007 15:41:58.0381 (UTC) FILETIME=[D3AB09D0:01C7D5E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-- james s

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/lpfc/lpfc_debugfs.c | 13809 -> 13716 (-93 bytes)
>  drivers/scsi/lpfc/lpfc_debugfs.o | 146124 -> 146124 (0 bytes)
> 
>  drivers/scsi/lpfc/lpfc_debugfs.c |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-26 13:07:42.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_debugfs.c	2007-07-31 14:11:24.000000000 +0200
> @@ -432,14 +432,11 @@ lpfc_debugfs_initialize(struct lpfc_vpor
>  	if (!lpfc_debugfs_start_time)
>  		lpfc_debugfs_start_time = jiffies;
> 
> -	vport->disc_trc = kmalloc(
> -		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc),
> -		GFP_KERNEL);
> +	vport->disc_trc = kcalloc(lpfc_debugfs_max_disc_trc,
> +				  sizeof(struct lpfc_disc_trc),	GFP_KERNEL);
> 
>  	if (!vport->disc_trc)
>  		goto debug_failed;
> -	memset(vport->disc_trc, 0,
> -		(sizeof(struct lpfc_disc_trc) * lpfc_debugfs_max_disc_trc));
> 
>  	snprintf(name, sizeof(name), "discovery_trace");
>  	vport->debug_disc_trc =
> 
