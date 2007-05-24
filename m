Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXEXVWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXEXVWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXEXVWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:22:11 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:40509 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbXEXVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:22:10 -0400
Message-ID: <465600A5.3040806@vmware.com>
Date: Thu, 24 May 2007 14:16:21 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ben Collins <ben.collins@ubuntu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] RTC: Ratelimit "lost interrupts" message
References: <98cd38b5.git.bcollins@ubuntu.com>	<e5ea703bf068a19cc9a4cc76a9b6b8990380ee75.1179964369.git.bcollins@ubuntu.com>	<20070524134822.ed020127.akpm@linux-foundation.org>	<1180040212.12570.279.camel@cunning> <20070524140956.12ff7c99.akpm@linux-foundation.org>
In-Reply-To: <20070524140956.12ff7c99.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>
>>> Presumably someone is getting a lot of these messages.
>>>
>>> Do we know why?  Is there something which needs fixing here?
>>>       
>> I got it a lot when using any sort of virtualization on my Core2Duo
>> (kvm, vmware, qemu). Just a big spew. Honestly, I was getting this with
>> 2.6.20, and haven't tested again with latest kernel.
>>     
>
> OK, a bit of googling finds things like this:
> http://chxo.com/be2/20060821_3333.html, so I assume that it's some sort of
> generic problem with the hypervisor's emulation of the RTC.
>
> Zach, do you know what the score is here?
>   

We at least jack up the rtc for fast clock timeouts with better 
granularity - so it can be a host kernel issue, although a guest kernel 
trying to get high frequency RTC will also be inaccurate, and inevitably 
will have unhidable interrupt lateness.

Ratelimiting seems the right thing to do, as once you have noted late 
RTC interrupts, it doesn't need to be noted again, and there is nothing 
you can do to fix it.  It is useful as a warning about interrupt 
disabled handlers taking too long, but there are other ways of detecting 
that too.

Zach

