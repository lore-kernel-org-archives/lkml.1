Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbXEIIGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbXEIIGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXEIIFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:05:23 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:39517 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756412AbXEIIFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:05:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=GhUvXJMcSy3XZuiAD0lm+OmLEck0qmrWeSWE78EG+CUuKCubNXrYRCNnFbkbox7hq0bn02pP6S9+ZoyuFVrjDUqaSm7zKsjWyoBMNaZc1K64k95LDCnG0KJydWhSPy5oKA1nf8z7FFUZILXKomz2b7I52iHLHNOj7VwfZH4swbM=  ;
X-YMail-OSG: fxl2eXoVM1k0g1l8pMAh3WNvpV_JAsKIW5Fa12uL3P51F3s1OiOcge.IAzbZYmbs3m4i.pEP5Q--
Message-ID: <464180B7.2090703@yahoo.com.au>
Date: Wed, 09 May 2007 18:05:11 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx> <4641643D.4040305@yahoo.com.au> <464169C8.9060002@drzeus.cx> <46416B9A.3020008@yahoo.com.au> <46417D97.9090108@drzeus.cx>
In-Reply-To: <46417D97.9090108@drzeus.cx>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Nick Piggin wrote:
> 
>>If you want to ensure you always only modify host->removed from under
>>the spinlock, it would be enforcable by introducing an accessor function
>>and doing a BUG_ON(!spin_is_locked()) in there.
>>
>>If you just want to ensure that host->removed is 0 at this point, you
>>shouldn't need any spinlocks AFAIKS... that way you can probably afford
>>to move it out from CONFIG_MMC_DEBUG and get wider testing.
>>
> 
> 
> The host->removed member is only used for this simple test. It is set in
> mmc_host_remove() to indicate that the removal process has begun. At
> this point it is invalid to call mmc_detect_change() (the place this
> patch fixes). So the spinlocks are mostly there so that things are
> properly ordered when we go SMP. Some creative barriers would probably
> work as well, but I find spinlocks more "normal" and hence more readable.

Fair enough. No big deal :)

-- 
SUSE Labs, Novell Inc.
