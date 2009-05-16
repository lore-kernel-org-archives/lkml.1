Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZEPW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZEPW1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756802AbZEPWS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:18:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:46404 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758815AbZEPWS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:18:57 -0400
Message-ID: <4A0F3BAA.1050907@kernel.org>
Date: Sun, 17 May 2009 07:18:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org,
       Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com,
       zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org> <4A0EC2AD.20704@ru.mvista.com> <4A0ECF8E.6000209@kernel.org> <4A0F1A55.8080701@ru.mvista.com>
In-Reply-To: <4A0F1A55.8080701@ru.mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 16 May 2009 22:17:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sergei.

Sergei Shtylyov wrote:
>> Similar response as the if/else one on the other thread.  Is it really
>> any significantly better?  The 'duplication' here is basically one
>> liner
> 
>   Not true, it's 3-liner. I wouldn't bother with one liner.

The final result is...

	req = blk_fetch_request(q);
	while (req) {
		int err = -EIO;

That looks like one liner to me.

>> after the peek/fetch change
> 
>   The peek/fetch code itself is duplicated. :-/

Do you mean by inlining?  Please note that blk_fetch_request() is not
inlined anymore after Fujita's bidi end_request cleanup patches.

>> and when the duplication is minimal,
>> I usually find it clearer to put the loop condition at the while
>> clause itself.
> 
>   No problem, we could just keep an old form of *while* loop.
> 
>> If you think it's significantly better,
> 
>   I do hink it avoids duplicating peek/fetch code.
> 
>> please go ahead and submit the patch but to me the change you're
>> proposing is
>> basically cosmetic and not even a clearly better one at that.
> 
> Should probably look at the resulting assembly to see how much it's
> differrent.

Do you seriously think it's worthwhile to optimize the request loop
according to assembly generation?  That sounds like a bad case of over
(micro) optimization to me.  It's not gonna make any noticeable
difference and the changes you make today can be irrelevant or even
deterimental tomorrow depending on any number of parameters.  Please
don't do it for performance reasons.

Thanks.

-- 
tejun
