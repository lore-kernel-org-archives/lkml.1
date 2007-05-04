Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXEDJnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXEDJnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXEDJnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:43:51 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:47618 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933064AbXEDJnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:43:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=lXKRa3AEOkhsKk63x/zuVRRKWpUgihdnzEMoo3YcnBNPHXsJlMzROqdcYC0GUmPJP1lfRTvhoZybi0xkS+8WoDPlFTBkB1vAaoWnBrZ7U+YYdzotbJtXJ+6iv6WJ1uOy69Q64wAxPRRf6D8Trh2a6dgGk+wiLisTrD8x4UKyDwc=  ;
X-YMail-OSG: MgfW4vkVM1kRdoxCezsZjVEA89yeQSKs3V_cT9V2ell7gXy904BRaMp_F_ipz8Uvn2wGM87kpQ--
Message-ID: <463B004D.6060402@yahoo.com.au>
Date: Fri, 04 May 2007 19:43:41 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrea Arcangeli <andrea@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.22 -mm merge plans -- vm bugfixes
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <4636FDD7.9080401@yahoo.com.au> <Pine.LNX.4.64.0705011931520.16502@blonde.wat.veritas.com> <4638009E.3070408@yahoo.com.au> <Pine.LNX.4.64.0705021418030.16517@blonde.wat.veritas.com> <46393BA7.6030106@yahoo.com.au> <20070503103756.GA19958@infradead.org> <4639DBEC.2020401@yahoo.com.au> <463AFB8C.2000909@yahoo.com.au>
In-Reply-To: <463AFB8C.2000909@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Nick Piggin wrote:
> 
>> Christoph Hellwig wrote:
> 
> 
>>> Is that every fork/exec or just under certain cicumstances?
>>> A 5% regression on every fork/exec is not acceptable.
>>
>>
>>
>> Well after patch2, G5 fork is 3% and exec is 1%, I'd say the P4
>> numbers will be improved as well with that patch. Then if we have
>> specific lock/unlock bitops, I hope it should reduce that further.
> 
> 
> OK, with the races and missing barriers fixed from the previous patch,
> plus the attached one added (+patch3), numbers are better again (I'm not
> sure if I have the ppc barriers correct though).
> 
> These ops could also be put to use in bit spinlocks, buffer lock, and
> probably a few other places too.
> 
> 2.6.21   1.49-1.51   164.6-170.8   741.8-760.3
> +patch   1.71-1.73   175.2-180.8   780.5-794.2
> +patch2  1.61-1.63   169.8-175.0   748.6-757.0
> +patch3  1.54-1.57   165.6-170.9   748.5-757.5
> 
> So fault performance goes to under 5%, fork is in the noise, exec is
> still up 1%, but maybe that's noise or cache effects again.

OK, with my new lock/unlock_page, dd if=large (bigger than RAM) sparse
file of=/dev/null with an experimentally optimal block size (32K) goes
from 626MB/s to 683MB/s on 2 CPU G5 booted with maxcpus=1.

-- 
SUSE Labs, Novell Inc.
