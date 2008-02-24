Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbYBXF3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbYBXF3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 00:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYBXF3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 00:29:24 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36081 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbYBXF3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 00:29:23 -0500
Message-ID: <47C100B0.1040408@garzik.org>
Date: Sun, 24 Feb 2008 00:29:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       linux-ide@vger.kernel.org
Subject: Re: power_state: get rid of write-only variable in SATA
References: <20080221125652.GA23548@elf.ucw.cz>
In-Reply-To: <20080221125652.GA23548@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> power_state is scheduled for removal, and libata uses it in write-only
> mode. Remove it.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index b4985bc..a31572d 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -6542,8 +6542,6 @@ int ata_host_suspend(struct ata_host *ho
>  	ata_lpm_enable(host);
>  
>  	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
> -	if (rc == 0)
> -		host->dev->power.power_state = mesg;
>  	return rc;
>  }
>  
> @@ -6562,7 +6560,6 @@ void ata_host_resume(struct ata_host *ho
>  {
>  	ata_host_request_pm(host, PMSG_ON, ATA_EH_SOFTRESET,
>  			    ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, 0);
> -	host->dev->power.power_state = PMSG_ON;
>  

applied


