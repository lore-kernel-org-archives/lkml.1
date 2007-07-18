Return-Path: <linux-kernel-owner+w=401wt.eu-S1764166AbXGRNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764166AbXGRNvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbXGRNvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:51:04 -0400
Received: from mail.tmr.com ([64.65.253.246]:42649 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXGRNvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:51:03 -0400
Message-ID: <469E1AA0.7030604@tmr.com>
Date: Wed, 18 Jul 2007 09:50:24 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Kent <raven@themaw.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] CFS scheduler, -v19
References: <MDEHLPKNGKAHNMBLJOLKKEBPFGAC.davids@webmaster.com> <1184738344.4178.18.camel@raven.themaw.net> <20070718075417.GA7895@elte.hu>
In-Reply-To: <20070718075417.GA7895@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ian Kent <raven@themaw.net> wrote:
>
>   
>>>> ah! It passes in a low-res time source into a high-res time 
>>>> interface (pthread_cond_timedwait()). Could you change the 
>>>> time(NULL) + 1 to time(NULL) + 2, or change it to:
>>>>
>>>> 	gettimeofday(&wait, NULL);
>>>> 	wait.tv_sec++;
>>>>
>>>> does this solve the spinning?
>>>>         
>> Yes, adding in the offset within the current second appears to resolve 
>> the issue. Thanks Ingo.
>>
>>     
>>>> i'm wondering how widespread this is. If automount is the only app 
>>>> doing this then _maybe_ we could get away with it by changing 
>>>> automount?
>>>>         
>> I don't think the change is unreasonable since I wasn't using an 
>> accurate time in the condition wait, so that's a coding mistake on my 
>> part which I will fix.
>>     
>
> thanks Ian for taking care of this and for fixing it!
>
> Linus, Thomas, what do you think, should we keep the time.c change? 
> Automount is one app affected so far, and it's a borderline case: the 
> increased (30%) CPU usage is annoying, but it does not prevent the 
> system from working per se, and an upgrade to a fixed/enhanced automount 
> version resolves it.
>
> The temptation of using a really (and trivially) scalable low-resolution 
> time-source (which is _easily_ vsyscall-able, on any platform) for DBMS 
> use is really large, to me at least. Should i perhaps add a boot/config 
> option that enables/disables this optimization, to allow distros finer
> grained control about this? And we've also got to wait whether there's
> any other app affected.
>   
Allow it to be selected by the "features" so that admins can evaluate 
the implications without a reboot?  That would be a convenient interface 
if you could provide it.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

