Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYKSRAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYKSRAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYKSRAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:00:40 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:54846 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYKSRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:00:39 -0500
Message-ID: <ac3eb2510811190900k62b1333aj9816e462601b4d0c@mail.gmail.com>
Date: Wed, 19 Nov 2008 18:00:37 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "rae l" <crquan@gmail.com>
Subject: Re: [PATCH] kobject_add: use constant strings directly as fmt strings
Cc: "Greg KH" <gregkh@suse.de>, "Jens Axboe" <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <91b13c310811190817s31522a0et744ca7df2782cf27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227110059-12529-1-git-send-email-crquan@gmail.com>
	 <20081119155736.GA5072@suse.de>
	 <91b13c310811190817s31522a0et744ca7df2782cf27@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 17:17, rae l <crquan@gmail.com> wrote:
> On Wed, Nov 19, 2008 at 11:57 PM, Greg KH <gregkh@suse.de> wrote:
>>>       ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
>>> -                       "%s", "queue");
>>> +                       "queue");
>>
>> Why?  What does this change buy us?
>
> Dropping one parameter makes the function call a little faster, doesn't it?
>
> The results are the same,

Not that we should be able to measure it, but it should save some
cycles parsing the format character and retrieving the string pointer
from the stack, yes.

> so if the string is constant, why not use it directly as the fmt string?

It should be fine for strings, where you can be sure they can never
contain a '%', sure.

Thanks,
Kay
