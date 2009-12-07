Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZLGSay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZLGSay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbZLGSax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:30:53 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63165 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112AbZLGSaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:30:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=imdsTE+AKBMtYTSbE1GjoqArrGQ4et1eTnmbIAxB5cnlmroVuLtIXxO775ri6HY2Hg
         zCgGt2VyLjtP/wrzfy++BjpMHSrs/AAUutNynJvub6uDxqYD9fs1VazoMFbKc55pd/ne
         MOjz85cSSgyL9Z4EhOMkxGWUw9TSKOQWDkoOQ=
MIME-Version: 1.0
In-Reply-To: <4B1BBE71.70305@gmail.com>
References: <b6fcc0a0912052114v790f04c9h9a7367ff74d12426@mail.gmail.com>
	 <4B1BBE71.70305@gmail.com>
Date: Mon, 7 Dec 2009 20:30:58 +0200
Message-ID: <b6fcc0a0912071030y4ca0deabk1635ec2f3e7ffe26@mail.gmail.com>
Subject: Re: [PATCH 28/31] Constify struct super_operations for 2.6.32 v1
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/6/09, Emese Revfy <re.emese@gmail.com> wrote:
> Alexey Dobriyan wrote:
>>> -   	struct inode *(*alloc_inode)(struct super_block *sb);
>>> +   	struct inode *(* const alloc_inode)(struct super_block *sb);
>>
>> Good rule is if adding const doesn't move object from one section
>> to another, it isn't worth it.
>>
>> I suggest we stick to it or risk another wave of jumbo patches.
>>
> If all instances of a given ops structure are const and we would like to
> preserve this policy for the future as well, then  it is very useful
> to give future programmers a strong hint about this policy by making
> the compiler complain about any violation attempts. Otherwise they may
> very well write code that modifies such structures and we will have to
> work extra to undo that (or change the policy but in that case it is
> good to know why we have to do that).

You may want to look what filesystems do with superblock operations.
And after super operations were made const writes to it will be caught
with readonly .rodata config option.

You're going too far with these modifiers.

Nothing will be caught.
