Return-Path: <linux-kernel-owner+w=401wt.eu-S968904AbXEIGEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968904AbXEIGEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934620AbXEIGEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:04:00 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:34794 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933482AbXEIGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:03:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=PKrM4Fkdx7hB0YyiqCqiyfAxJGDbYr9l4hAqda35lyDr9clMQMZVPjIj0/9eu6QVitPK3VMhLiHel04uqlQYZSvwqMaJPGHFayGBcAfkIQNPq3qzRf2PgTsRclF8qZ29gRqz9SijDupb+FnZoddnn619xCSt6QXXuYG6oKqV06c=  ;
X-YMail-OSG: RvD6WMsVM1mjwaEQUovpxOF0lvwXVRAqW3y3S8.Pu42fXDR8OfCKq.8lhGNbniTFG_f6pTnf_Wj_eCcddY3A3rG9IQfv_GQ4eDyq7D5Iu62EM4yGw_Z859ToYwM9MQ--
Message-ID: <4641643D.4040305@yahoo.com.au>
Date: Wed, 09 May 2007 16:03:41 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx>
In-Reply-To: <46416255.3060105@drzeus.cx>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Pierre Ossman wrote:
> 
>>Linus, please pull from
>>
>>        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-linus
>>
> 
> 
> fsck! I pushed the wrong branch :/
> 
> This fix should have been in the last commit.
> 
> Sorry,
> 
> 
> ------------------------------------------------------------------------
> 
> commit 3b9a6d78eb439016728c598a1373b50328f5e9fe
> Author: Pierre Ossman <drzeus@drzeus.cx>
> Date:   Wed May 9 07:53:28 2007 +0200
> 
>     mmc: fix wrong call to spinlock
>     
>     Fix silly typo in spinlock calls.
>     
>     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> 
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index b6c1670..7385acf 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -501,9 +501,9 @@ void mmc_detect_change(struct mmc_host *host, unsigned long delay)
>  {
>  #ifdef CONFIG_MMC_DEBUG
>  	unsigned long flags;
> -	spin_lock_irqsave(host->lock, flags);
> +	spin_lock_irqsave(&host->lock, flags);
>  	BUG_ON(host->removed);
> -	spin_unlock_irqrestore(host->lock, flags);
> +	spin_unlock_irqrestore(&host->lock, flags);
>  #endif

Do you actually need the lock there at all? What is it protecting?

-- 
SUSE Labs, Novell Inc.
