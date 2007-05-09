Return-Path: <linux-kernel-owner+w=401wt.eu-S935097AbXEIGf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097AbXEIGf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968609AbXEIGfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:35:21 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:40542 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967647AbXEIGfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:35:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=JYgKRIVviBSi0Nu6U4Z4zVp6O3Uyjfv/4HE3zyxq3EPeono6WHlFD7H06d8UJX38lIXuGdak8gApq0GZYxfm7bzmSgmTz0WNg50cv1fToB+OjsM0T6WzUO57LyWqyQWlIMIBRr19P51rJT5eVKiyTq8T8+yoYy+W90h7LDAg1CY=  ;
X-YMail-OSG: 1tOy14oVM1lRFEymSSiPhdskCOudZqCZef_XgUNjvfPE5fGDMeh01r0HYgFZH3mm1e0mC.jkAg--
Message-ID: <46416B9A.3020008@yahoo.com.au>
Date: Wed, 09 May 2007 16:35:06 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx> <4641643D.4040305@yahoo.com.au> <464169C8.9060002@drzeus.cx>
In-Reply-To: <464169C8.9060002@drzeus.cx>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Nick Piggin wrote:
> 
>>>@@ -501,9 +501,9 @@ void mmc_detect_change(struct mmc_host *host,
>>>unsigned long delay)
>>> {
>>> #ifdef CONFIG_MMC_DEBUG
>>>     unsigned long flags;
>>>-    spin_lock_irqsave(host->lock, flags);
>>>+    spin_lock_irqsave(&host->lock, flags);
>>>     BUG_ON(host->removed);
>>>-    spin_unlock_irqrestore(host->lock, flags);
>>>+    spin_unlock_irqrestore(&host->lock, flags);
>>> #endif
>>
>>Do you actually need the lock there at all? What is it protecting?
>>
> 
> 
> It makes sure we don't have any race when it comes to modifying
> host->removed.

If you want to ensure you always only modify host->removed from under
the spinlock, it would be enforcable by introducing an accessor function
and doing a BUG_ON(!spin_is_locked()) in there.

If you just want to ensure that host->removed is 0 at this point, you
shouldn't need any spinlocks AFAIKS... that way you can probably afford
to move it out from CONFIG_MMC_DEBUG and get wider testing.

-- 
SUSE Labs, Novell Inc.
