Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZGGACn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZGGACn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZGFX7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 19:59:44 -0400
Received: from elasmtp-scoter.atl.sa.earthlink.net ([209.86.89.67]:51421 "EHLO
	elasmtp-scoter.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756162AbZGFX7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 19:59:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=UxHBTx7nTxNhuuEMjsM7I5S6PpZlPjIw2kETKPd2jWHfgUD/DZdG61M1jpCakNZB;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Message-Id: <933218BE-421F-4F94-8D44-21A95810F4BA@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: Mitchell Erblich <erblichs@earthlink.net>
In-Reply-To: <3DE21B02-7ABA-4E56-961C-1DFB608DBE43@earthlink.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re : .... get_page_from_freelist : MInority Suggestion to accept GFP_NOFAIL accept during boot
Date: Mon, 6 Jul 2009 16:59:42 -0700
References: <61448F53-1F7A-47EF-AAF3-CB2A46AB8009@earthlink.net> <alpine.DEB.2.00.0907030155250.13657@chino.kir.corp.google.com> <3DE21B02-7ABA-4E56-961C-1DFB608DBE43@earthlink.net>
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec79126ac3c767bb0ce938697e3bfbdb82bd350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

	Make plain text so vger.kernel.org will accept this..

	Mitchell Erblich
	====================

On Jul 6, 2009, at 4:56 PM, Mitchell Erblich wrote:

> David,
>
> 		The web page http://lkml.indiana.edu/hypermail/linux/kernel/
>
> 		Looking at the thread of emails on June 24 at 11:07:23
> 		upcoming kerneloops.org item: get_page_from_freelist
>
> 		We have code from Arjan de Van
>
> it's this warning in mm/page_alloc.c:
>
> * __GFP_NOFAIL is not to be used in new code.
> *
> * All __GFP_NOFAIL callers should be fixed so that they
> * properly detect and handle allocation failures.
> *
> * We most definitely don't want callers attempting to
> * allocate greater than single-page units with
> * __GFP_NOFAIL.
> */
> WARN_ON_ONCE(order > 0);
>
>
> 	Mitchell Erblich
> 	======================
> 		
> On Jul 3, 2009, at 2:01 AM, David Rientjes wrote:
>
>> On Thu, 2 Jul 2009, Mitchell Erblich wrote:
>>
>>> Group,
>>>
>>>
>>> 	If I may suggest a minority opinion about the depreciating of the
>>> GFP_NOFAIL flag..
>>>
>>> 	I saw no discussion on the acceptance of using this flag during  
>>> boot
>>> and shortly
>>> 	after boot.
>>>
>>> 	Many kernel structures require memory and thus should guarantee  
>>> memory
>>> 	before they continue.
>>> 	
>>> 	As Linux is moved within embedded environments with smaller  
>>> amounts of
>>> 	physical memory, the chance that earlier mem failures becomes  
>>> higher.
>>>
>>> 	For this logic alone, my minority opinion is to not depreciate the
>>> GFP_NOFAIL flag.
>>>
>>
>> I'm confused by your request because all allocations with orders  
>> under
>> PAGE_ALLOC_COSTLY_ORDER are inherently __GFP_NOFAIL and those that  
>> are not
>> can easily implement the same behavior in the caller:
>>
>> 	struct page *page;
>> 	do {
>> 		page = alloc_pages(...);
>> 	} while (!page);
>>
>> Hopefully something could be done to ensure the next call to  
>> alloc_pages()
>> would be more likely to succeed, but __GFP_NOFAIL doesn't provide  
>> that
>> anyway.
>

