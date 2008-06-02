Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYFBChd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYFBChd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbYFBCh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:37:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:51015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYFBChZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:37:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=vsFf6coJDWSq4US7BKWzduF5cwwMoIlZ0OGIM+19pIAk3jVq5UYTr4nA9oKl3f46HKCloAvKGmzbTmsAw/u2XDIQl2gvMMbtt4s980YAI3cCZL1buVkoZ5GVZ9z1MKSMPaB7AgG5B9QTTdXzfyNFXk/GN1sbCnfWHJlQCYUDoaQ=
Message-ID: <48435CCA.5000905@gmail.com>
Date: Sun, 01 Jun 2008 21:36:58 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Guntsche Michael <mike@it-loops.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.x: Wrong CPU frequency (cpufreq table) with p4-clockmod
References: <12C649C0-4BEF-41F1-B738-8C8CEF8AEBB8@it-loops.com>	<20080530065717.44cf7414@infradead.org>	<F2473A1D-E4F5-4B9D-9538-B122553E1011@it-loops.com>	<E234E250-922E-45F6-B01E-0B3CDC80A8ED@it-loops.com> <20080601185643.3d3db64f@infradead.org>
In-Reply-To: <20080601185643.3d3db64f@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sun, 1 Jun 2008 23:57:14 +0200
> Guntsche Michael <mike@it-loops.com> wrote:
> 
>> On May 30, 2008, at 16:07, Guntsche Michael wrote:
>>
>>> I am most interested in keeping the temperature of my CPU down,  
>>> which means slower fans, which means less noise.
>>> The main "problem" I have is that I do not know if this is a
>>> simple display issue or if I am having a more fundamental problem
>>> here.
>> Just FYI I found out the cause of my problem.
>>
>> Reverting
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ed9cbcd40004904dbe61ccc16d6106a7de38c998
>> this patch resultsin the correct numbers for me.
>>
>> <cpuinfo snip>
>> processor	: 0
>> vendor_id	: GenuineIntel
>> cpu family	: 15
>> model		: 1
>> model name	: Intel(R) Pentium(R) 4 CPU 1.70GHz
>> stepping	: 2
>> cpu MHz		: 637.500
>> <snip>
>>
>> This patch was reverted because other people seem to have problems  
>> with it, reverting the revert does not look like a good idea either.
>> But since I know now, that this is just a "display" problem and  
>> everything is working otherwise, I'll just patch this locally for my  
>> machine here.
>>
> 
> just as a side note.. you do realize that with p4-clockmod, your cpu is
> still running at 1.7 GHz right? (it's just doing less work '-)

 From my testing, I believe the only thing that p4-clockmod does is forces an 
idle call when it could otherwise do work on an active process, so fullspeed and 
idle uses *EXACTLY* the same amount of power as p4-clockmod slower speed and 
idle (and therefore generates exactly the same amount of heat), the only power 
difference would be that if you were using p4-clockmod to slow down the cpu when 
it had an active running process (force the cpu to be idle a lot of the time 
even though it has work).   Arjan's point is that if you are using  p4-clockmod 
to slow down an idle cpu in hopes of saving power when the cpu is not being 
used, then it is not going to make *ANY* difference in the power usage at all.

I tried it on my p4 here, and cannot see any power difference in idle/fullspeed 
and idle/slowspeed, this is unlike the later power saving stuff that actually 
does slow down the cpu frequency, and you can measure a different amount of 
power usage with the different clock speeds and an idle cpu.

                                    Roger
