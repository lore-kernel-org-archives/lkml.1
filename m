Return-Path: <linux-kernel-owner+w=401wt.eu-S1759290AbXHWLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290AbXHWLOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbXHWLOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:14:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:43876 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbXHWLOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=PvdwFI/m6O5uCctd8SEu9j7PjjQBMjjLkaRy3yyoKfIHjO/wtEQ++pWvnyRXdKak2CJYWQyoRU3ioOwRJlr2T6UXvofJA6URHwtqpxSWYkWDOvoxFms/chi81sulXJ9aap1qXAqn0d8V5YVrPnxLObJrD6JZiGvJg8/fZkWi2NU=
Message-ID: <46CD6BF4.2080101@googlemail.com>
Date: Thu, 23 Aug 2007 13:13:56 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Stephen Smalley <sds@tycho.nsa.gov>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [2.6.20.17 review 00/58] 2.6.20.17 -stable review
References: <6bffcb0e0708220410u4ab3978eq18786ac186e88c7d@mail.gmail.com> <Xine.LNX.4.64.0708220621550.28878@us.intercode.com.au> <1187789765.1451.310.camel@moss-spartans.epoch.ncsc.mil> <1187790174.1451.315.camel@moss-spartans.epoch.ncsc.mil> <Xine.LNX.4.64.0708220707390.9414@us.intercode.com.au> <6bffcb0e0708220729j7b9afcf3v4edef68cc974c08d@mail.gmail.com> <Xine.LNX.4.64.0708220929370.4968@us.intercode.com.au> <6bffcb0e0708220946hc2943f5jdb33215cdfab08d1@mail.gmail.com> <6bffcb0e0708221050s68975158k7a3b27c7c30f455d@mail.gmail.com> <1187810114.1451.453.camel@moss-spartans.epoch.ncsc.mil> <20070822201634.GB14132@1wt.eu>
In-Reply-To: <20070822201634.GB14132@1wt.eu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau pisze:
> On Wed, Aug 22, 2007 at 03:15:14PM -0400, Stephen Smalley wrote:
>> On Wed, 2007-08-22 at 19:50 +0200, Michal Piotrowski wrote:
>>> On 22/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>>> On 22/08/07, James Morris <jmorris@namei.org> wrote:
>>> [snip]
>>>>> The previous problem is theoretically unrelated.  It arose via a separate
>>>>> mechanism which can't be used at the same as the one you're seeing now in
>>>>> the logs.
>>>>>
>>>>> So this either looks like a problem which has gone unnoticed and was
>>>>> inadvertently fixed at some point, or is unique to the 2.6.20 stable
>>>>> series.
>>>> Yup, it is very interesting why no one noticed it. Binary search in progress:
>>>> good - 2.6.20.4
>>>> bad - 2.6.20.8
>>> Ok, I narrowed the problem to 2.6.20.7. There are a few net changes
>>> http://eu.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20.7
>>> any suggestions?
>>>
>>> I also have seen this avc on 2.6.20.6 during reboot
>>>
>>> [ 2333.905944] audit(1187803699.273:271): avc:  denied  { send } for
>>> saddr=192.168.1.70 src=48591 daddr=72.14.217.189 dest=80 netif=eth0
>>> scontext=user_u:system_r:unconfined_t:s0
>>> tcontext=system_u:system_r:kernel_t:s0 tclass=packet
>>> [ 2334.420598] audit(1187803699.789:272): avc:  denied  { send } for
>>> saddr=192.168.1.70 src=47248 daddr=66.249.91.18 dest=80 netif=eth0
>>> scontext=user_u:system_r:unconfined_t:s0
>>> tcontext=system_u:system_r:kernel_t:s0 tclass=packet
>>>
>>> so the roots of the problem may lie between 2.6.20.4 and 2.6.20.6
>>>
>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.20.17-rc1/console2.log
>> Might be related to this:
>> http://marc.info/?l=git-commits-head&m=118271540932264&w=2
> 
> Interesting, this one was fixed in 2.6.22-rc6, but is neither in 2.6.20
> nor in 2.6.21. Michal, could you please try to apply the patch ? I include
> it here for your convenience. If it fixes your problem, I can queue it for
> next 2.6.20-stable, and forward it to the -stable team for 2.6.21 in case
> Greg and Chris plan to release another one.
> 

I confirm that this patch fixes the problem.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
