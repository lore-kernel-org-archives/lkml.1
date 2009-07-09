Return-Path: <linux-kernel-owner+w=401wt.eu-S1761110AbZGIQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110AbZGIQwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbZGIQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:52:06 -0400
Received: from av12-2-sn2.hy.skanova.net ([81.228.8.186]:60297 "EHLO
	av12-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720AbZGIQwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:52:05 -0400
Message-ID: <4A56202C.9020809@mocean-labs.com>
Date: Thu, 09 Jul 2009 18:51:56 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kwangwoo.lee@gmail.com, thierry.reding@avionic-design.de,
       soni.trilok@gmail.com
Subject: Re: [PATCH 1/2] tsc2007: remove HR timer
References: <4A40C288.2060702@mocean-labs.com> <20090625142010.bd656a9d.akpm@linux-foundation.org>
In-Reply-To: <20090625142010.bd656a9d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/09 11:20 PM, Andrew Morton wrote:
> On Tue, 23 Jun 2009 13:54:48 +0200
> Richard R__jfors<richard.rojfors.ext@mocean-labs.com>  wrote:
>
>> This patch removes the HR timer, since it's bad to do synchronous I2C
>> in the HR timer callback context. The new implementation makes use
>> of the global workqueue. The work is scheduled every 5ms when polling
>> rather than 5 us.
>>
>
> "it's bad" isn't a very good description of the problem which the patch
> fixes.

The problem is that the synchronous I2C calls in HR-timer callback 
context might end up in a deadlock.

>
> This matters.  People wish to make decisions about whether this patch
> is needed in 2.6.29.x, 2.6.30.x, 2.6.31, 2.6.32, etc.  Without knowing
> the effects of the problem which the patch fixes, we cannot make that
> decision!
>
>> +	/* cancel any work */
>> +	cancel_delayed_work(&ts->work);
>> +
>
> Should this have been cancel_delayed_work_sync()?

It should, I will post a new patch shortly which should be applied after 
these two which fixes this.

--Richard
