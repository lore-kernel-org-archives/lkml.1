Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab0CKJ07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:26:59 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:44288 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab0CKJ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:26:57 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
References: <20100310123257.GA2899@frolo.macqel>
	<87d3zc1bjo.fsf@devron.myhome.or.jp>
	<20100310161429.GA16799@frolo.macqel>
	<87hboow105.fsf@devron.myhome.or.jp>
	<20100310235808.GA4353@frolo.macqel>
Date: Thu, 11 Mar 2010 18:26:54 +0900
In-Reply-To: <20100310235808.GA4353@frolo.macqel> (Philippe De Muyter's
	message of "Thu, 11 Mar 2010 00:58:08 +0100")
Message-ID: <87bpevryxt.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

>> >> This introduces unneeded directory-parse to standard one.  And for
>> >
>> > No.  There will only be a second parse if someone is looking for a filename
>> > with a trailing dot, and it is not found (*).  I there is no trailing dot in qname, only the first fat_search_long will be called, because len after vfat_striptail_len would be equal to qname->len.
>> 
>> Yes, I'm saying about trailing-dot filename case. Any disadvantage to
>> standard one is unacceptable to workaround.
>
> This is unavoidable.

We would be able to introduce new mount option to do it if needed.

>> 	$ ls
>>         a.. a. a
>>         $ rm -rf *
>> 
>>         $ ls
>>         a..
>>         $ touch a.
>>         $ touch a
>> ...
>> 
>> I assumed you want to define "a." and "a" are different name on
>> "mv a a.", and _totally_.
>
> For file creation and renaming, I want to introduce no change, because there
> is no problem.  If one wants to create a "a." file on a IO-MEGA disk suing
> linux and USB, it is currently called "a", and that will remain exactly the
> same.

This changed vfat_find(), so, this patch will change the behavior of all
callers more or less. And the behavior seems to be really strange, you
can remove "a.", but you can't create it? The behavior sounds random,
right?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
