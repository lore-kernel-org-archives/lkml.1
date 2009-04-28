Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbZD1Qv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbZD1Qv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758107AbZD1QvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:51:16 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50861 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714AbZD1QvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <49F7308A.2010804@kernel.org>
References: <20090418192314.GA22107@suse.de> <49F6B1E6.7050008@kernel.org> 
	<49F6B350.9080703@kernel.org> <ac3eb2510904280125w11a58388u6a51997e28609009@mail.gmail.com> 
	<49F71EF6.3050102@kernel.org> <49F72205.7030306@kernel.org> 
	<20090428153906.GA8896@suse.de> <49F7260F.8030405@kernel.org> 
	<ac3eb2510904280856m1fc07002pc4fb630fd2946b62@mail.gmail.com> 
	<49F7308A.2010804@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 28 Apr 2009 18:50:52 +0200
Message-ID: <ac3eb2510904280950i761bb122p74299e0ff5b3a86e@mail.gmail.com>
Subject: Re: [RFC PATCH] use dev_set_name(,NULL) to prevent leaking
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 18:36, Yinghai Lu <yinghai@kernel.org> wrote:
> Kay Sievers wrote:
>> On Tue, Apr 28, 2009 at 17:51, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> before device_register==>device_initialize is called, kobj->ref is still 0.
>>>
>>> will get warn from
>>>                if (!kobj->state_initialized)
>>
>> Initialize the device before you do anything with it. And call _put()
>> any time to get rid of ressources, which might have been allocated
>> before registering.
>
> need to replace device_register with device_add and call device_initialize before device_set_name?

Sounds right in the case you want to jump out between set_name() and
_register() -- means you have an uninitialized device, where you can
not call put_device(). Otherwise after a failing _register() it should
work fine.

Kay
