Return-Path: <linux-kernel-owner+w=401wt.eu-S1750838AbZCYIBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838AbZCYIBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbZCYIBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:01:08 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:61338 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZCYIBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:01:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xv6jduGiu43apMaBLCw7tnYzT49xCmOInKnKP2ENsp1wVPXgq0QmaUT+tjhXSrQXjR
         tRNJV6VbWmA+BZkyDhRyIMFKB7N91hCFcAOn+5DejmpOiLyagGIoe+iZJXjAyyh8uNCA
         1clHCG2rZrAYomMfdjSqXJdv7dKCtn3feUbt4=
Message-ID: <49C9E4B8.3000708@gmail.com>
Date: Wed, 25 Mar 2009 09:00:56 +0100
From: =?UTF-8?B?Sm9zw6kgTWFyw63CrWEgRmVybsOhbmRleiBHb256w6FsZXo=?= 
	<josemariafg@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090323)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mmc: Some microSD cards are not recognized by PCIxx12
 SDA controller
References: <49B5C091.3090303@gmail.com> <20090324211748.30cd7429@mjolnir.ossman.eu>
In-Reply-To: <20090324211748.30cd7429@mjolnir.ossman.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Tue, 10 Mar 2009 02:21:21 +0100
>> diff -Nrpu linux-2.6.28.5/drivers/mmc/core/core.c.orig linux-2.6.28.5/drivers/mmc/core/core.c
>> --- linux-2.6.28.5/drivers/mmc/core/core.c.orig	2009-03-10 01:30:19.000000000 +0100
>> +++ linux-2.6.28.5/drivers/mmc/core/core.c	2009-03-10 01:29:44.000000000 +0100
>> @@ -514,7 +514,7 @@ static void mmc_power_up(struct mmc_host
>>  	 * This delay should be sufficient to allow the power supply
>>  	 * to reach the minimum voltage.
>>  	 */
>> -	mmc_delay(2);
>> +	mmc_delay(10);
>>  
> 
> A delay of 10 is just enough to trigger a sleep on most kernels
> (HZ=100). Have you determined the lower bound of these two values?
> 

Well, I have been using the patch in a kernel with HZ=300, tickless (CONFIG_NO_HZ) and desktop preemption (CONFIG_PREEMPT_VOLUNTARY), but I didn't determine the lower bound. As I explained in the patch at -mm tree, I took as base the patch:

http://list.drzeus.cx/pipermail/sdhci-devel/2007-December/002089.html

and I only extrapolated the need for a higher delay just after MMC_POWER_UP to this one and after MMC_POWER_ON. When I was looking for a fix for the problem I was suffering with my microSD card and laptop, I remember I found some e-mails from two years ago pointing out to some change in the scheduler which uncovered the problem.

As I'm going to install 2.6.29 today, I can test the patch with it and HZ=100.
