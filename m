Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbZKYWZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbZKYWZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 17:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759228AbZKYWZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 17:25:34 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:55380 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759124AbZKYWZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 17:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=A3K6EhDU7hFTDtkgyzHJTpmGpAjjWAnCQfivsMnSWMLln0XS/JY5y8bj9IRamB9pWG
         lXnsSmGs7yaxolZ43LRsaH1q7gS5KEA4+A0afZTEAP/O8G101xuKyN32GF2XPRmzWVpA
         fCafySQmExK03B2h+3UYglTT4RlR5r+vpK+W0=
MIME-Version: 1.0
In-Reply-To: <20091125140422.cdee4a0d.akpm@linux-foundation.org>
References: <1259162390-378-1-git-send-email-cliffcai.sh@gmail.com> 
	<20091125140422.cdee4a0d.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 25 Nov 2009 17:25:20 -0500
Message-ID: <8bd0f97a0911251425q178993fete79b675e2730bdec@mail.gmail.com>
Subject: Re: [PATCH v4][mmc/host]:Blackfin SD Host Controller Driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cliffcai.sh@gmail.com, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, cliff.cai@analog.com,
       Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 17:04, Andrew Morton wrote:
> On Wed, 25 Nov 2009 23:19:50 +0800 cliffcai.sh wrote:
>> +struct dma_desc_array {
>> +     unsigned long   start_addr;
>> +     unsigned short  cfg;
>> +     unsigned short  x_count;
>> +     short           x_modify;
>> +} __attribute__((packed));
>
> __packed is preferred.

we should move this into the Blackfin dma.h at any rate

>> +static void sdh_start_cmd(struct sdh_host *host, struct mmc_command *cmd)
>> +{
>> +     unsigned int sdh_cmd;
>> +     unsigned int stat_mask;
>> +
>> +     dev_dbg(mmc_dev(host->mmc), "%s enter cmd: 0x%p\n", __func__, cmd);
>> +     WARN_ON(host->cmd != NULL);
>> +     host->cmd = cmd;
>> +
>> +     sdh_cmd = 0;
>> +     stat_mask = 0;
>> +
>> +     sdh_cmd |= cmd->opcode;
>> +
>> +     if (cmd->flags & MMC_RSP_PRESENT) {
>> +             sdh_cmd |= CMD_RSP;
>> +             stat_mask |= CMD_RESP_END;
>> +     } else
>> +             stat_mask |= CMD_SENT;
>
> Arguably wrong from a coding-style POV and looks weird IMO.  Adds a bit
> of risk that subsequent coders will think they're writing in python adn
> will add bugs.

i dont really get what you're referring to here.  the code in question
looks ifne to me, and i dont see anything "python-esque" about it

> Fixes:
>
> -       } else
> +       } else }

guessing you actually meant '{' there
-mike
