Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbYEUUc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbYEUUc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 16:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764481AbYEUUbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 16:31:48 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:52127 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761318AbYEUUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 16:31:47 -0400
Date: Wed, 21 May 2008 13:25:52 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Andreas Schwab <schwab@suse.de>
cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <je3aocdqxh.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0805211300590.5706@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
 <jeiqx83ab0.fsf@sykes.suse.de> <Pine.LNX.4.64.0805201502000.7453@t2.domain.actdsltmp>
 <jeabik385g.fsf@sykes.suse.de> <Pine.LNX.4.64.0805201612240.7453@t2.domain.actdsltmp>
 <je3aocdqxh.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Andreas Schwab wrote:
> Trent Piepho <tpiepho@freescale.com> writes:
>> On Wed, 21 May 2008, Andreas Schwab wrote:
>>> Trent Piepho <tpiepho@freescale.com> writes:
>>>> It's the _le versions that have a problem, since we can't get gcc to just use
>>>> the register indexed mode.  It seems like an obvious thing to have a
>>>> constraint for, but I guess there weren't enough instructions that only come
>>>> in 'x' versions to bother with it.  There is a 'Z' constraint, "Memory operand
>>>> that is an indexed or indirect from a register", but I tried it and it can use
>>>> both "rb,ri" and "disp(rb)" forms.  Actually, I'm not sure how 'Z' is any
>>>> different than "m"?
>>>
>>> 'Z' will never emit a non-zero constant displacement.
>>
>> It's too bad gas doesn't appear to be smart enough to turn:
>>         stwbrx 0, 0(3)   -or-   stwbr 0, 0(3)
>
> Use the %y modifier when substituting the operand.

Of course, the undocumented y modifier!  "Print AltiVec or SPE memory operand"
Why didn't I think of that?

That appears to work.  I can get gcc to to emit 0,reg and reg,reg but not
disp(reg).  It won't try to use an "update" address either, though it will
with an "m" constraint.

But, gcc 4.0.2 can't handle the 'Z' constraint.  It looks like it's not
supported.  Other than this, I can build a kernel with 4.0.2 that appears to
work.  Is it ok to break compatibility with 4.0.2, or should I put in a gcc
version check?
