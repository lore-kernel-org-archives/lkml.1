Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZDQIE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZDQIE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 04:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZDQIEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 04:04:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54870 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZDQIEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 04:04:01 -0400
Message-ID: <49E837EC.5000202@redhat.com>
Date: Fri, 17 Apr 2009 10:03:56 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: simplify I/O stat accounting
References: <49E72F19.1030400@redhat.com> <20090416163456.GR5178@kernel.dk> <20090416163728.GS5178@kernel.dk> <20090416163831.GT5178@kernel.dk> <20090416164253.GU5178@kernel.dk>
In-Reply-To: <20090416164253.GU5178@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Apr 16 2009, Jens Axboe wrote:
>> On Thu, Apr 16 2009, Jens Axboe wrote:
>>> On Thu, Apr 16 2009, Jens Axboe wrote:
>>>> On Thu, Apr 16 2009, Jerome Marchand wrote:
>>>>> This simplifies I/O stat accounting switching code and separates it
>>>>> completely from I/O scheduler switch code.
>>>>>
>>>>> Requests are accounted according to the state of their request queue
>>>>> at the time of the request allocation. There is no need anymore to
>>>>> flush the request queue when switching I/O accounting state.
>>>> This is cleaner, I like it. I'll apply it, but I'm changing this one:
>>>>
>>>>> @@ -792,9 +792,10 @@ static struct request *get_request(struct
>>>>> request_queue *q, int rw_flags,
>>>>>  	if (priv)
>>>>>  		rl->elvpriv++;
>>>>>
>>>>> +	iostat = blk_queue_io_stat(q) ? REQ_IO_STAT : 0;
>>>>>  	spin_unlock_irq(q->queue_lock);
>>>> to a regular if, I hate these ?: constructs. An if is much more
>>>> readable, imho.
>>> Grmbl, your patch is line wrapped. Please fix your mailer.
>> And it doesn't apply to current -git. Looks like a hand apply, but
>> please be a little more careful in the future.
> 
> OK, it doesn't even compile either:
> 
> +#define blk_rq_io_stat(rq)     ((rq)->flags & REQ_IO_STAT)
> 
> that wants to be ->cmd_flags.
> 
> Please resend when you have something that at least compiles. If you
> send untested stuff my way, at least tell me.
> 

Hi Jens,

I'm very sorry about this. I didn't send you a patch which does not
compiles on purpose. I was working on backporting that patch on an older
version of the kernel. It looks like I hand-edited that patch by mistake
before I sent it to you.

Jérôme
