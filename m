Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbZBIK4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbZBIK4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 05:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZBIK4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 05:56:24 -0500
Received: from h155.mvista.com ([63.81.120.155]:8356 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbZBIK4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 05:56:23 -0500
Message-ID: <49900BD1.9040305@ru.mvista.com>
Date: Mon, 09 Feb 2009 13:56:17 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>, Mikael Pettersson <mikpe@it.uu.se>
Cc: Hugh Dickins <hugh@veritas.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
References: <200902082253.07438.sshtylyov@ru.mvista.com>	<Pine.LNX.4.64.0902082108290.18661@blonde.anvils>	<498F5A25.90707@ru.mvista.com> <18831.28471.454273.451912@harpo.it.uu.se> <498F72C8.8020204@ru.mvista.com> <498F767B.9060701@pobox.com> <499008B7.3020404@ru.mvista.com>
In-Reply-To: <499008B7.3020404@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> The answer depends on workload.  Though rare, workloads do exist that 
>> involve a lot of oddball querying via weird, vendor-specific 
>> SCSI[-ish] commands.
>   Do you really think that the transfers having lengths non-divisible 
> by 4 make any *significant* percentage even on the ATAPI devices? I 
> think it's you who is really wrong.
>
>   Can you give an example of a *continous* querying with the data 
> transferring commands?
>   Hm, it just occured to me that the typical ATAPI command packet is 
> 12 bytes long.

   Haha, I even can't count! 12 divides by 4, of course. :-D

>> Or a more human version of the rule:  if you have to have a long 
>> email thread about unlikely() placement, it is best just to avoid 
>> using unlikely() in that case at all.  Branch prediction units in 
>> modern CPUs are damned good anyways, and there is always the 
>> likelihood that a human-placed unlikely() becomes wrong in the 
>> future. Moreover, the likelihood and cost of a branch mispredict are 
>> both low in this case, IMO.
>
>   There are still CPUs without the branch prediction, you know -- 
> Linux runs not only on x86.
>
>> Plus the code is more readable without unlikely(), IMO.
>
>   I tend to disagree. However, the packet command transfer is not 
> unlikely at all, so I'll remove that unlikely() in the respun patch.

   No, I'll keep it now. This case is indeed unlikely.

>>     Jeff

MBR, Sergei


