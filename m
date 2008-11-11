Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYKKWi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYKKWi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYKKWir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:38:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYKKWiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:38:46 -0500
Message-ID: <491A0957.9060606@redhat.com>
Date: Wed, 12 Nov 2008 00:38:15 +0200
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>	<1226409701-14831-2-git-send-email-ieidus@redhat.com>	<1226409701-14831-3-git-send-email-ieidus@redhat.com>	<1226409701-14831-4-git-send-email-ieidus@redhat.com>	<20081111150345.7fff8ff2@bike.lwn.net>	<491A0483.3010504@redhat.com> <20081111153028.422b301a@bike.lwn.net>
In-Reply-To: <20081111153028.422b301a@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> [Let's see if I can get through the rest without premature sends...]
>
> On Wed, 12 Nov 2008 00:17:39 +0200
> Izik Eidus <ieidus@redhat.com> wrote:
>
>   
>>> Actually, it occurs to me that there's no sanity checks on any of
>>> the values passed in by ioctl().  What happens if the user tells
>>> KSM to scan a bogus range of memory?
>>>     
>>>       
>> Well get_user_pages() run in context of the process, therefore it
>> should fail in "bogus range of memory"
>>     
>
> But it will fail in a totally silent and mysterious way.  Doesn't it
> seem better to verify the values when you can return a meaningful error
> code to the caller?
>
>   

Well I dont mind insert it (the above for sure is not a bug)
but even with that, the user can still free the memory that he gave to us
so this check if "nice to have check", we have nothing to do but to relay on
get_user_pages return value :)

> The other ioctl() calls have the same issue; you can start the thread
> with nonsensical values for the number of pages to scan and the sleep
> time.
>   

well about this i agree, here it make alot of logic to check the values!



