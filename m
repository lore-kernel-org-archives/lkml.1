Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYCYJ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYCYJ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 05:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbYCYJ6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 05:58:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:18141 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbYCYJ6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:58:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ao+SF+kCYrRls7kfgDTui9WSHpWiBc8VMOhqwUC1Kks84HOjFkTIytORAGUUVCA/nnavV0075LVKfGitWo4oI+cY9BKT/py72oHmhIMgdBj1eaq/ohCPgtGdaGVx9YVnsnwuoR0MSRWsvjo6I0gNIai5dwwSpFw7gXAvbDCpXrM=
Message-ID: <31e679430803250258u3bb8b29esb5fa5f7d435674b8@mail.gmail.com>
Date: Tue, 25 Mar 2008 11:58:40 +0200
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Carlos Aguiar" <carlos.aguiar@indt.org.br>
Subject: Re: [PATCH 01/18] MMC: OMAP: Remove some opcodes from host driver
Cc: "Pierre Ossman" <drzeus-list@drzeus.cx>,
       "Tony Lindgren" <tony@atomide.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47DAD3A1.9090702@indt.org.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47DAD3A1.9090702@indt.org.br>
X-Google-Sender-Auth: b1e7e7461e9a20ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 9:36 PM, Carlos Aguiar
<carlos.aguiar@indt.org.br> wrote:
> From: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
>
>  This patch removes some opcodes from host driver so there's no need on putting
>  '#include <linux/mmc/mmc.h>', that should not be needed in host drivers.
>

You should update this patch and remove the '#include
<linux/mmc/mmc.h>' from omap.c

>  Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
>  ---
>   drivers/mmc/host/omap.c |   11 +++--------
>   1 files changed, 3 insertions(+), 8 deletions(-)
>
>  diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
>  index c9dfeb1..eb7175a 100644
>  --- a/drivers/mmc/host/omap.c
>  +++ b/drivers/mmc/host/omap.c
>  @@ -495,15 +495,10 @@ static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
>                 if (status & OMAP_MMC_STAT_CMD_TOUT) {
>                         /* Timeouts are routine with some commands */
>                         if (host->cmd) {
>  -                               if (host->cmd->opcode != MMC_ALL_SEND_CID &&
>  -                                               host->cmd->opcode !=
>  -                                               MMC_SEND_OP_COND &&
>  -                                               host->cmd->opcode !=
>  -                                               MMC_APP_CMD &&
>  -                                               !mmc_omap_cover_is_open(host))
>  +                               if (!mmc_omap_cover_is_open(host))
>                                         dev_err(mmc_dev(host->mmc),
>  -                                               "command timeout, CMD %d\n",
>  -                                               host->cmd->opcode);
>  +                                       "command timeout, CMD %d\n",
>  +                                       host->cmd->opcode);
>                                 host->cmd->error = -ETIMEDOUT;
>                                 end_command = 1;
>                         }
>  -- 1.5.3.GIT
>
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
