Return-Path: <linux-kernel-owner+w=401wt.eu-S1756645AbYBDRRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbYBDRRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 12:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYBDRRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 12:17:05 -0500
Received: from mail-relay-02.mailcluster.net ([77.221.130.214]:41723 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbYBDRRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 12:17:03 -0500
Message-ID: <47A7488B.4080000@vlnb.net>
Date: Mon, 04 Feb 2008 20:16:59 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Bart Van Assche <bart.vanassche@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	 <1201639331.3069.58.camel@localhost.localdomain>	 <47A05CBD.5050803@vlnb.net>  <47A7049A.9000105@vlnb.net>	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net> <1202144767.3096.38.camel@localhost.localdomain>
In-Reply-To: <1202144767.3096.38.camel@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>>>>So, James, what is your opinion on the above? Or the overall SCSI target 
>>>>project simplicity doesn't matter much for you and you think it's fine 
>>>>to duplicate Linux page cache in the user space to keep the in-kernel 
>>>>part of the project as small as possible?
>>>
>>>
>>>The answers were pretty much contained here
>>>
>>>http://marc.info/?l=linux-scsi&m=120164008302435
>>>
>>>and here:
>>>
>>>http://marc.info/?l=linux-scsi&m=120171067107293
>>>
>>>Weren't they?
>>
>>No, sorry, it doesn't look so for me. They are about performance, but 
>>I'm asking about the overall project's architecture, namely about one 
>>part of it: simplicity. Particularly, what do you think about 
>>duplicating Linux page cache in the user space to have zero-copy cached 
>>I/O? Or can you suggest another architectural solution for that problem 
>>in the STGT's approach?
> 
> 
> Isn't that an advantage of a user space solution?  It simply uses the
> backing store of whatever device supplies the data.  That means it takes
> advantage of the existing mechanisms for caching.

No, please reread this thread, especially this message: 
http://marc.info/?l=linux-kernel&m=120169189504361&w=2. This is one of 
the advantages of the kernel space implementation. The user space 
implementation has to have data copied between the cache and user space 
buffer, but the kernel space one can use pages in the cache directly, 
without extra copy.

Vlad
