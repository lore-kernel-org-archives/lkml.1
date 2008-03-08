Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYCHVj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYCHVj2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYCHVjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:39:14 -0500
Received: from webaccess-cl.virtdom.com ([216.240.101.25]:61791 "EHLO
	webaccess-cl.virtdom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYCHVip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:38:45 -0500
Date: Sat, 8 Mar 2008 11:38:27 -1000 (HST)
From: Jeff Roberson <jroberson@chesapeake.net>
X-X-Sender: jroberson@desktop
To: Davide Libenzi <davidel@xmailserver.org>
cc: Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] eventfd signal race in aio_complete()
In-Reply-To: <Pine.LNX.4.64.0803081236440.9905@alien.or.mcafeemobile.com>
Message-ID: <20080308113744.J1091@desktop>
References: <20080307161854.E920@desktop> <Pine.LNX.4.64.0803071955490.13626@alien.or.mcafeemobile.com>
 <20080308102321.4527372e@bree.surriel.com> <Pine.LNX.4.64.0803081236440.9905@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008, Davide Libenzi wrote:

> On Sat, 8 Mar 2008, Rik van Riel wrote:
>
>> On Fri, 7 Mar 2008 20:29:20 -0800 (PST)
>> Davide Libenzi <davidel@xmailserver.org> wrote:
>>
>>> The second solution/patch simply moves the eventfd_signal() call before
>>> the __aio_put_req() call, but after the event has beed "ringed".
>>> We should be clear to go with the shorter/nicer second solution. Those
>>> patches builds, but I'm not even signing them off till I tested them.
>>
>> If there are no spinlock ordering issues between &ctx->ctx_lock
>> and &ctx->wqh.lock (taken inside eventfd_signal), then the second
>> patch is indeed preferable.
>>
>> Jeff and I did look at that briefly last night, but were not
>> familiar enough with the code to decide whether or not that was
>> safe.
>
> There's no interlocking between the two, so let's go with #2.
> Jeff, would you mind giving patch #2 a spin in your test suite?

I agree #2 would be best as well.  It may take me a few days due to some 
equipment issues but I will get back to you as soon as I can.

Thanks,
Jeff

>
>
>
> - Davide
>
>
