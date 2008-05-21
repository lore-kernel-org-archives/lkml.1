Return-Path: <linux-kernel-owner+w=401wt.eu-S934654AbYEUIEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbYEUIEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 04:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761755AbYEUID6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 04:03:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:44347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758464AbYEUID5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 04:03:57 -0400
From: Andreas Schwab <schwab@suse.de>
To: Trent Piepho <tpiepho@freescale.com>
Cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com>
	<jeiqx83ab0.fsf@sykes.suse.de>
	<Pine.LNX.4.64.0805201502000.7453@t2.domain.actdsltmp>
	<jeabik385g.fsf@sykes.suse.de>
	<Pine.LNX.4.64.0805201612240.7453@t2.domain.actdsltmp>
X-Yow: Is this "BOOZE"?
Date: Wed, 21 May 2008 10:03:54 +0200
In-Reply-To: <Pine.LNX.4.64.0805201612240.7453@t2.domain.actdsltmp> (Trent
	Piepho's message of "Tue, 20 May 2008 16:14:49 -0700 (PDT)")
Message-ID: <je3aocdqxh.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho <tpiepho@freescale.com> writes:

> On Wed, 21 May 2008, Andreas Schwab wrote:
>> Trent Piepho <tpiepho@freescale.com> writes:
>>
>>> It's the _le versions that have a problem, since we can't get gcc to just use
>>> the register indexed mode.  It seems like an obvious thing to have a
>>> constraint for, but I guess there weren't enough instructions that only come
>>> in 'x' versions to bother with it.  There is a 'Z' constraint, "Memory operand
>>> that is an indexed or indirect from a register", but I tried it and it can use
>>> both "rb,ri" and "disp(rb)" forms.  Actually, I'm not sure how 'Z' is any
>>> different than "m"?
>>
>> 'Z' will never emit a non-zero constant displacement.
>
> It's too bad gas doesn't appear to be smart enough to turn:
>         stwbrx 0, 0(3)   -or-   stwbr 0, 0(3)

Use the %y modifier when substituting the operand.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
