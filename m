Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYDJMJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYDJMJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYDJMJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:09:03 -0400
Received: from ns.suse.de ([195.135.220.2]:59996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbYDJMJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:09:02 -0400
From: Andreas Schwab <schwab@suse.de>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Roel Kluin <12o3l@tiscali.nl>, linux-mm@kvack.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pagewalk: don't pte_unmap(NULL) in walk_pte_range()
References: <47FC95AD.1070907@tiscali.nl> <87zls3qhop.fsf@saeurebad.de>
X-Yow: I'm sitting on my SPEED QUEEN..  To me, it's ENJOYABLE..
 I'm WARM..  I'm VIBRATORY..
Date: Thu, 10 Apr 2008 14:09:00 +0200
In-Reply-To: <87zls3qhop.fsf@saeurebad.de> (Johannes Weiner's message of "Wed\,
	09 Apr 2008 15\:30\:30 +0200")
Message-ID: <jer6dd9ajn.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>> index 1cf1417..6615f0b 100644
>> --- a/mm/pagewalk.c
>> +++ b/mm/pagewalk.c
>> @@ -15,7 +15,7 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  		       break;
>>  	} while (pte++, addr += PAGE_SIZE, addr != end);
>>  
>> -	pte_unmap(pte);
>> +	pte_unmap(pte - 1);
>>  	return err;
>>  }
>
> This does not make any sense to me.

There is something fishy here.  If the loop ends because addr == end
then pte has been incremented past the pmd page for addr, no?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
