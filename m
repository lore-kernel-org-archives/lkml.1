Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbZJPT26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbZJPT26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZJPT25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:28:57 -0400
Received: from mail.lang.hm ([64.81.33.126]:45956 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbZJPT25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:28:57 -0400
Date: Fri, 16 Oct 2009 12:28:49 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Holger Kiehl <Holger.Kiehl@dwd.de>
cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-raid <linux-raid@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Raid reconstructing and process hanging in D state
In-Reply-To: <Pine.LNX.4.64.0910160840400.2463@praktifix.dwd.de>
Message-ID: <alpine.DEB.2.00.0910161226170.22169@asgard.lang.hm>
References: <Pine.LNX.4.64.0910160703260.2463@praktifix.dwd.de> <alpine.DEB.2.00.0910160436160.2841@p34.internal.lan> <Pine.LNX.4.64.0910160840400.2463@praktifix.dwd.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, Holger Kiehl wrote:

> On Fri, 16 Oct 2009, Justin Piszcz wrote:
>> Hi,
>> 
>> I have the same problem with mdadm/raid-1, if you do not limit the speed in 
>> the speed_limit_min paramter, it will starve the I/O from all other 
>> processes and result in the same problem you are having.
>> 
> But in my case speed_limit_min was set to 1000 and speed_limit_max was 200000
> (ie. the default) and this still caused all process to hang in D-state. Only
> lowering speed_limit_max helped to make the system responsive again.

yep, MD raid will use every bit of disk bandwidth there is.

even worse, the speed_limit_* appears to be per-drive, not per array 
(although the /proc/mdstat info is per array), so if you have lots of 
drives on one controller card it will kill the system and still think that 
it's not maxed out.

I did a 45 disk array hooked into two PCI slots and found that I needed to 
set speed_limit_max _very_ low to avoid this sort of problem.

David Lang

>> But for me I'm not sure about the reconstruction-- this happens for me 
>> during a raid verify/check.
>> 
> This was also the case for me, during a raid verify/check.
>
> Holger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
