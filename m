Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbYGAEFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbYGAEFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 00:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750746AbYGAEF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 00:05:28 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40560 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYGAEFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 00:05:22 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Fix the case of jiffies wrapping in mm/pdflush.c
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp>
	<129170883e848699cff211608.ps@mail.parknet.co.jp>
	<d3ce91fd3e848699cff311608.ps@mail.parknet.co.jp>
	<5be8ad613e848699cff411608.ps@mail.parknet.co.jp>
	<555b858b3e848699cff511608.ps@mail.parknet.co.jp>
	<670df4283e848699cff611608.ps@mail.parknet.co.jp>
	<a553a85a3e848699d00711608.ps@mail.parknet.co.jp>
	<20080630203401.f9bcfe84.akpm@linux-foundation.org>
Date: Tue, 01 Jul 2008 13:05:18 +0900
In-Reply-To: <20080630203401.f9bcfe84.akpm@linux-foundation.org> (Andrew
	Morton's message of "Mon, 30 Jun 2008 20:34:01 -0700")
Message-ID: <87od5iw8ox.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

>> @@ -151,7 +151,7 @@ static int __pdflush(struct pdflush_work
>>  		if (nr_pdflush_threads <= MIN_PDFLUSH_THREADS)
>>  			continue;
>>  		pdf = list_entry(pdflush_list.prev, struct pdflush_work, list);
>> -		if (jiffies - pdf->when_i_went_to_sleep > 1 * HZ) {
>> +		if (time_after(jiffies, pdf->when_i_went_to_sleep + 1 * HZ)) {
>>  			/* Limit exit rate */
>>  			pdf->when_i_went_to_sleep = jiffies;
>>  			break;					/* exeunt */
>
> I don't think this actually "fixes" anything, does it?  The old code
> should be correct at runtime.

Um.. Yes. It seems I tested something wrong.

> I renamed the patch to "pdflush: use time_after() instead of open-coding it".

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
