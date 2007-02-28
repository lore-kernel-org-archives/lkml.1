Return-Path: <linux-kernel-owner+w=401wt.eu-S1751796AbXB1PfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbXB1PfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 10:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbXB1PfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 10:35:09 -0500
Received: from mail.cse.ohio-state.edu ([164.107.123.5]:57063 "EHLO
	cse.ohio-state.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbXB1PfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 10:35:08 -0500
Message-ID: <45E5A0E4.2000301@cse.ohio-state.edu>
Date: Wed, 28 Feb 2007 10:33:56 -0500
From: Xiaoning Ding <dingxn@cse.ohio-state.edu>
User-Agent: Thunderbird 1.5.0.9 (X11/20061215)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Benoit Boissinot <bboissin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: a bug in AS scheduler?
References: <45E5038F.1090200@cse.ohio-state.edu> <20070228121040.GW3733@kernel.dk> <40f323d00702280525g3d898a9bm1297dc32b8f7fda2@mail.gmail.com> <20070228133458.GC3733@kernel.dk>
In-Reply-To: <20070228133458.GC3733@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Feb 28 2007, Benoit Boissinot wrote:
>> On 2/28/07, Jens Axboe <jens.axboe@oracle.com> wrote:
>>> On Tue, Feb 27 2007, Xiaoning Ding wrote:
>>>> Hi,
>>>>
>>>> I am reading the source code AS scheduler in 2.6.18(as-ioscheduler.c).
>>>> In function as_close_req, variable delay is in millisecond, while
>>>> ad->antic_expire is in jiffies. Doesn't the comparison of delay and
>>>> ad->antic_expire make any problem?
>>>> The related source code is quoted blow:
>>>>
>>>>       if (ad->antic_status == ANTIC_OFF || !ad->ioc_finished)
>>>>               delay = 0;
>>>>       else
>>>>               delay = ((jiffies - ad->antic_start) * 1000) / HZ;
>>> antic_start is in jiffies, the difference is here multiplied by 1000 and
>>> divided by HZ to turn it into msecs. so delay is in msecs.
>>>
>> I am pretty sure Xiaoning was talking about antic_expire, particularly
>> this comparison:
>>
>>     else if (delay <= 20 && delay <= ad->antic_expire)
> 
> Ah, I misread the name. That does look like a bug, antic_expire is in
> jiffies.

You got it.

Xiaoning

