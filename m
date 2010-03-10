Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab0CJRQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:16:32 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:48415 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0CJRQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:16:30 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH vfat] allow retrieving entries with trailing dots
References: <20100310123257.GA2899@frolo.macqel>
	<87d3zc1bjo.fsf@devron.myhome.or.jp>
	<20100310161429.GA16799@frolo.macqel>
Date: Thu, 11 Mar 2010 02:16:26 +0900
In-Reply-To: <20100310161429.GA16799@frolo.macqel> (Philippe De Muyter's
	message of "Wed, 10 Mar 2010 17:14:30 +0100")
Message-ID: <87hboow105.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philippe De Muyter <phdm@macqel.be> writes:

>> This introduces unneeded directory-parse to standard one.  And for
>
> No.  There will only be a second parse if someone is looking for a filename
> with a trailing dot, and it is not found (*).  I there is no trailing dot in qname, only the first fat_search_long will be called, because len after vfat_striptail_len would be equal to qname->len.

Yes, I'm saying about trailing-dot filename case. Any disadvantage to
standard one is unacceptable to workaround.

>> IO-MEGA, this wouldn't provide proper filename handling.
>
> For accessing IO-MEGA disk in read mode, this is perfect.  I didn't want
> to replicate IO-MEGA write behaviour here, only fix the read behaviour for
> such simple commands as 'ls', 'find' and all the directory browsers.
>
>> If it wants to handle the tailing-dot as a part of filename, it
>> shouldn't be able to access to the stripped-dots filename. (For simple
>> example, I guess you can't do "mv a a." with this patch.)
>
> As I explained above, I only fix read-access on IO-MEGA drives, while
> preserving standard behaviour for write mode.
>
> But I'll try your testcase asap.  Which behaviour do you expect ?
> I would expect a no-op, because I did not change the write-behaviour.

Those sound like strange.  Well, I expect there is no any change to
standard one for IO-MEGA.

And I can't see what is your read-access mean in here. What did this
expect to behave like e.g. following operations,

	$ ls
        a.. a. a
        $ rm -rf *

        $ ls
        a..
        $ touch a.
        $ touch a
...

I assumed you want to define "a." and "a" are different name on
"mv a a.", and _totally_.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
