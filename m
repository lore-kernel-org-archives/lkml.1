Return-Path: <linux-kernel-owner+w=401wt.eu-S965674AbXAZN6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965674AbXAZN6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 08:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965675AbXAZN6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 08:58:47 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:29518 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965674AbXAZN6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 08:58:47 -0500
Message-ID: <45BA0B7C.1090304@sw.ru>
Date: Fri, 26 Jan 2007 17:09:00 +0300
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: vatsa@in.ibm.com
CC: riel@redhat.com, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fair-user scheduler
References: <20070126060142.GA2487@in.ibm.com>
In-Reply-To: <20070126060142.GA2487@in.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa,

> Current Linux CPU scheduler doesnt recognize process aggregates while
> allocating bandwidth. As a result of this, an user could simply spawn large 
> number of processes and get more bandwidth than others.
> 
> Here's a patch that provides fair allocation for all users in a system.
> 
> Some benchmark numbers with and without the patch applied follows:
> 
> 
> 		 	user "vatsa"		    user "guest"
> 		    (make -s -j4 bzImage)      (make -s -j20 bzImage)
> 
> 2.6.20-rc5		472.07s (real)		   257.48s (real)
> 2.6.20-rc5+fairsched	766.74s (real)		   766.73s (real)
1. If I interpret these numbers correctly, then your scheduler is not work-conservative,
i.e. 766.74 + 766.73 >> 472.07 + 257.48
why does it slow down users so much?
2. compilation of kernel is quite CPU-bound task. So it's not that hard to be fair :)
   Can you please try some other applications?
   e.g. pipe-based context switching, java Volano benchmark etc.

Thanks,
Kirill

