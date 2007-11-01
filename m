Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbXKANbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbXKANbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXKANbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:31:32 -0400
Received: from mail.suse.de ([195.135.220.2]:54964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXKANbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:31:32 -0400
From: Andreas Schwab <schwab@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <aacraid@adaptec.com>, <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] aacraid: don't assign cpu_to_le32(constant) to u8
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	<20071101173221.2e1fea42.sfr@canb.auug.org.au>
X-Yow: I just had a NOSE JOB!!
Date: Thu, 01 Nov 2007 14:31:29 +0100
In-Reply-To: <20071101173221.2e1fea42.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Thu\, 1 Nov 2007 17\:32\:21 +1100")
Message-ID: <jefxzqqeha.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index 240a0bb..3c2dbc0 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aac)
>  			aif = (struct aac_aifcmd *)hw_fib->data;
>  			aif->command = cpu_to_le32(AifCmdEventNotify);
>  		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
> -		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
> -			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
> -		 	aif->data[2] = cpu_to_le32(AifHighPriority);
> +			aif->data[0] = AifEnExpEvent;
> +			aif->data[1] = AifExeFirmwarePanic;
> +			aif->data[2] = AifHighPriority;
>  			aif->data[3] = cpu_to_le32(BlinkLED);

What about the last line?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
