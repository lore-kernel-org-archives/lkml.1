Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXFNSQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXFNSQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXFNSQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:16:20 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:45739 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXFNSQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:16:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Date: Thu, 14 Jun 2007 18:16:03 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C0156B740@G3W0639.americas.hpqcorp.net>
In-Reply-To: <20070614153119.GC32137@hmsreliant.homelinux.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cciss: force ignore of responses to unsent scsi commands after kexec reboot
Thread-Index: AceumVCfmU2K2QuWQTmky5+1XtzPpwAFondQ
References: <20070614153119.GC32137@hmsreliant.homelinux.net>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Neil Horman" <nhorman@tuxdriver.com>, <linux-kernel@vger.kernel.org>
Cc: "ISS StorageDev" <iss_storagedev@hp.com>, <akpm@linux-foundation.org>
X-OriginalArrivalTime: 14 Jun 2007 18:16:04.0670 (UTC) FILETIME=[123B45E0:01C7AEB0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Neil Horman [mailto:nhorman@tuxdriver.com] 
> Sent: Thursday, June 14, 2007 10:31 AM
> To: linux-kernel@vger.kernel.org
> Cc: Miller, Mike (OS Dev); ISS StorageDev; 
> akpm@linux-foundation.org; nhorman@tuxdriver.com
> Subject: [PATCH] cciss: force ignore of responses to unsent 
> scsi commands after kexec reboot
> 
> Hey -
> 	cciss hardware currently can continue to send responses 
> to scsi commands after the host system has undergone a kexec 
> reboot.  The way the drier is currently written, reception of 
> these commands results in a BUG halt, since it can't match 
> the response to any issued command since the boot.  This 
> patch corrects that by using the kexec reset_devices command 
> line paramter to force ignore any commands that it cant correlate.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  cciss.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index 5acc6c4..ec1c1d2 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -2131,6 +2131,14 @@ static int add_sendcmd_reject(__u8 
> cmd, int ctlr, unsigned long complete)
>  		       ctlr, complete);
>  		/* not much we can do. */
>  #ifdef CONFIG_CISS_SCSI_TAPE
> +		/* We might get notification of completion of commands
> +		 * which we never issued in this kernel if this boot is
> +		 * taking place after previous kernel's crash. Simply
> +		 * ignore the commands in this case.
> +		 */
> +		if (reset_devices)
> +			return 0;
> +
>  		return 1;
>  	}
>  
I don't understand how this will help. We need to reset the controller
which reset_devices cannot do alone. I just haven't have the time to
implement the fix yet.

mikem 
