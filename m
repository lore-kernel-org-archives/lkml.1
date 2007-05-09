Return-Path: <linux-kernel-owner+w=401wt.eu-S968726AbXEIG2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968726AbXEIG2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934867AbXEIG2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:28:13 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:35741 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933773AbXEIG2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:28:13 -0400
Message-ID: <464169C8.9060002@drzeus.cx>
Date: Wed, 09 May 2007 08:27:20 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx> <4641643D.4040305@yahoo.com.au>
In-Reply-To: <4641643D.4040305@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>> @@ -501,9 +501,9 @@ void mmc_detect_change(struct mmc_host *host,
>> unsigned long delay)
>>  {
>>  #ifdef CONFIG_MMC_DEBUG
>>      unsigned long flags;
>> -    spin_lock_irqsave(host->lock, flags);
>> +    spin_lock_irqsave(&host->lock, flags);
>>      BUG_ON(host->removed);
>> -    spin_unlock_irqrestore(host->lock, flags);
>> +    spin_unlock_irqrestore(&host->lock, flags);
>>  #endif
>
> Do you actually need the lock there at all? What is it protecting?
>

It makes sure we don't have any race when it comes to modifying
host->removed. We had some problems where controllers reported card
insertion events even after they'd signaled to be removed, causing all
kind of odd problems. This check was added to easier spot it should it
arise again.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

