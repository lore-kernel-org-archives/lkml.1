Return-Path: <linux-kernel-owner+w=401wt.eu-S935841AbXHHPNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935841AbXHHPNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935568AbXHHPMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:12:38 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1404 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935506AbXHHPMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:12:35 -0400
Message-ID: <46B9DCAE.4010009@openvz.org>
Date: Wed, 08 Aug 2007 19:09:34 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@osdl.org>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Add ability to print calltraces tighter on i386
References: <46B9D08F.8080402@openvz.org> <p73zm12qc8a.fsf@bingen.suse.de>
In-Reply-To: <p73zm12qc8a.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Pavel Emelyanov <xemul@openvz.org> writes:
> 
>> When printing a BUG or OOPS report the longest part of it is
>> the calltrace, which sometimes (quite often) doesn't fit the
>> standard 25-lines display. This may become a bad news when the
>> system doesn't have a serial/net console and is completely frozen so
>> that the terminal scrolling doesn't work.
>>
>> The information that hides from the developer is registers, the
>> top of the calltrace and information about the kernel and the
>> crashed process (uname). As our experience shows, seeing this info is
>> sometimes critical and having a short calltrace would help a lot.
>>
>> The proposal is to make a boot-option called "tight_trace", that
>> makes the calltrace show only the addresses in one line instead
>> of the symbol names one per line.
>>
>> E.g. OOPSes of 50 lines occupy ~20 with this patch.
>>
>> This is an example of how it will look for i386, but if this
>> will be found useful, I will make the patch for other arched
>> I can test it on (at least x86_64, ia64).
> 
> Just use a higher resolution with vga=... 
> I have yet to see an oops that doesn't fit on 80x50

Not everyone likes frame buffer but even with it any OOPs in 
network code which happens in softirq, io scheduler and nearby 
code that is called after passing through all the VFS hooks 
and many other examples produce long oopses.

Oops-es with only the calltrace of ~50 lines do happen :)

> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

