Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbZCPRU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbZCPRU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbZCPRUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:20:17 -0400
Received: from gw.goop.org ([64.81.55.164]:45344 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZCPRUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:20:16 -0400
Message-ID: <49BE8A4D.7040204@goop.org>
Date: Mon, 16 Mar 2009 10:20:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org>
In-Reply-To: <49BE84D6.3010006@kernel.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Ingo Molnar wrote:
>>     
>>>> And the resulting kernel booted fine under qemu with 1Gbyte of
>>>> memory.  I'll try on real hardware a bit later, but it doesn't seem
>>>> like something that should be affected by qemu vs native, unless it
>>>> has something to do with the specific e820 map.
>>>>     
>>>>         
>>> Note that the crash was reproducible and it very clearly went away
>>> when i excluded those commits from tip:master.
>>>   
>>>       
>> Yep, and it looks like the kind of problem those changes might cause. 
>> But I can't reproduce it, and its not obvious to me what's actually
>> going wrong.  Any chance you could bisect the failure down to a specific
>> changeset, and print "start", "max_pfn_mapped" and "tables" where it fails?
>>
>>     
>
> could be max_pfn_mapped change in head_32.S that reduce mapping range to _end only.
>   

Oh, you mean rather than including all low memory?  Possible.  I can 
reproduce it now, so I should be able to sort it out now.

    J
