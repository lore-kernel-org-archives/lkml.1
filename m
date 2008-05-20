Return-Path: <linux-kernel-owner+w=401wt.eu-S934280AbYETWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280AbYETWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761059AbYETWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:16:17 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:35688 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823AbYETWQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:16:16 -0400
Date: Tue, 20 May 2008 15:11:02 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Andreas Schwab <schwab@suse.de>
cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <jeiqx83ab0.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0805201502000.7453@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
 <jeiqx83ab0.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Andreas Schwab wrote:
> Trent Piepho <tpiepho@freescale.com> writes:
>
>> For the LE versions, eventually they boil down to an asm that will look
>> something like this:
>> asm("sync; stwbrx %1,0,%2" : "=m" (*addr) : "r" (val), "r" (addr));
>>
>> While not perfect, this appears to be the best one can do.  The issue is
>> that the "stwbrx" instruction only comes in an indexed, or 'x', version, in
>> which the address is represented by the sum of two registers (the "0,%2").
>> Unfortunately, gcc doesn't have a constraint for an indexed memory
>> reference.
>
> There is the "Z" constraint, which matches either an indirect or an
> indexed memory address.  That should fit here.

This came up on the Freescale list.  I should have put what I wrote there into
my patch descrition:

It's the _le versions that have a problem, since we can't get gcc to just use
the register indexed mode.  It seems like an obvious thing to have a
constraint for, but I guess there weren't enough instructions that only come
in 'x' versions to bother with it.  There is a 'Z' constraint, "Memory operand
that is an indexed or indirect from a register", but I tried it and it can use
both "rb,ri" and "disp(rb)" forms.  Actually, I'm not sure how 'Z' is any
different than "m"?
