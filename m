Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXEJOZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXEJOZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXEJOZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:25:46 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:38933 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762701AbXEJOZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:25:45 -0400
Message-ID: <46432B43.9060709@panasas.com>
Date: Thu, 10 May 2007 17:25:07 +0300
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Joerg Roedel <joerg.roedel@amd.com>
CC: Pete Zaitcev <zaitcev@redhat.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Andi, you broke my laptop :-)
References: <20070509125616.cde56b8e.zaitcev@redhat.com> <20070510130144.GI14898@one.firstfloor.org> <20070510133555.GA5705@amd.com> <20070510141942.GM14898@one.firstfloor.org>
In-Reply-To: <20070510141942.GM14898@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2007 14:25:09.0929 (UTC) FILETIME=[03B45190:01C7930F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg's patch works for me too.

Thanks,

Benny

Andi Kleen wrote:
> On Thu, May 10, 2007 at 03:35:56PM +0200, Joerg Roedel wrote:
>> On Thu, May 10, 2007 at 03:01:44PM +0200, Andi Kleen wrote:
>>> On Wed, May 09, 2007 at 12:56:16PM -0700, Pete Zaitcev wrote:
>>>> Hi, Andi:
>>>>
>>>> The attached patch (actually, git show output) makes my Dell 1501 to hang
>>>> on boot. Sorry, I have no clue why... The culprit is found with git bisect.
>>>> But yes, it's an AMD MK-36. I use an x86_64 kernel. It is 100% reproducible.
>>> MK-36? Does it have SVM? 
>>>
>>> Anyways we previously had issues with this being miscompiled, but 
>>> I thought the latest patch should have been ok. What compiler do you use?
>>>
>>> Can you send me a disassembly listing of arch/x86_64/kernel/time.o?
>> I debugged this problem a bit and my compiler[1]interprets the =A
>> constraint as %rax instead of %edx:%eax on x86_64 which causes the
>> problem. The appended patch provides a workaround for this and fixed the
>> hang on my machine.
> 
> Hmm yes now I can reproduce it too. I didn't see any hangs so i suppose 
> my (and that of most -mm tester's) compiled binary always happened to have a 
> suitable value in edx
> 
> Thanks for the patch.
> 
> -Andi
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Benny Halevy
Panasas Inc.
Accelerating Time to Results(TM) with Clustered Storage

www.panasas.com
bhalevy@panasas.com
Tel/Fax: +972-3-647-8340
Mobile: +972-54-802-8340
