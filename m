Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXGRBY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXGRBY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXGRBYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:24:51 -0400
Received: from mail.tmr.com ([64.65.253.246]:42447 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbXGRBYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:24:51 -0400
Message-ID: <469D6BD8.8050703@tmr.com>
Date: Tue, 17 Jul 2007 21:24:40 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ian Kent <raven@themaw.net>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] CFS scheduler, -v19
References: <20070706173319.GA2356@elte.hu> <1184054902.12336.19.camel@Homer.simpson.net> <469512C1.6090406@tmr.com> <20070711205556.GA27266@elte.hu> <4697EC49.4070303@tmr.com> <469BE462.9030004@redhat.com> <20070716215541.GA27171@elte.hu> <1184648474.3188.33.camel@raven.themaw.net> <20070717074537.GA13539@elte.hu> <1184671021.3188.51.camel@raven.themaw.net> <20070717171643.GB7905@elte.hu>
In-Reply-To: <20070717171643.GB7905@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ian Kent <raven@themaw.net> wrote:
>
>   
>>> ah! It passes in a low-res time source into a high-res time interface 
>>> (pthread_cond_timedwait()). Could you change the time(NULL) + 1 to 
>>> time(NULL) + 2, or change it to:
>>>
>>> 	gettimeofday(&wait, NULL);
>>> 	wait.tv_sec++;
>>>       
>> OK, I'm with you, hi-res timer.
>> But even so, how is the time in the past after adding a second.
>>
>> Is it because I'm not setting tv_nsec when it's close to a second 
>> boundary, and hence your recommendation above?
>>     
>
> yeah, it looks a bit suspicious: you create a +1 second timeout out of a 
> 1 second resolution timesource. I dont yet understand the failure mode 
> though that results in that looping and in the 30% CPU time use - do you 
> understand it perhaps? (and automount is still functional while this is 
> happening, correct?)
>   

Can't say, I have automount running because I get it by default, but I 
have nothing using at on my test machine. Why is it looping so fast when 
there are no mount points defined? If the config changes there's no 
requirement to notice right away, is there?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

