Return-Path: <linux-kernel-owner+w=401wt.eu-S935714AbZLHAEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935714AbZLHAEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935331AbZLHAEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:04:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47383 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935305AbZLHAEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:04:36 -0500
Message-ID: <4B1D988E.2000305@gmail.com>
Date: Tue, 08 Dec 2009 01:06:38 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>	 <4B1BBE71.70305@gmail.com> <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com>
In-Reply-To: <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On 12/6/09, Emese Revfy <re.emese@gmail.com> wrote:
>> Alexey Dobriyan wrote:
>>>> -   	struct inode *(*alloc_inode)(struct super_block *sb);
>>>> +   	struct inode *(* const alloc_inode)(struct super_block *sb);
>>> Good rule is if adding const doesn't move object from one section
>>> to another, it isn't worth it.
>>>
>>> I suggest we stick to it or risk another wave of jumbo patches.
>>>
>> If all instances of a given ops structure are const and we would like to
>> preserve this policy for the future as well, then  it is very useful
>> to give future programmers a strong hint about this policy by making
>> the compiler complain about any violation attempts. Otherwise they may
>> very well write code that modifies such structures and we will have to
>> work extra to undo that (or change the policy but in that case it is
>> good to know why we have to do that).
> 
> You may want to look what filesystems do with superblock operations.
> And after super operations were made const writes to it will be caught
> with readonly .rodata config option.
> 
> You're going too far with these modifiers.
> 
> Nothing will be caught.

DEBUG_RODATA catches the unwanted write attempt at runtime whereas
my patch will catch it at compile time. I think it's better to detect
an error as early as possible.
--
Emese
