Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYDIL6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYDIL6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYDIL6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:58:46 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:50233 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYDIL6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=MurODrVqRGtG8otsvDnOfQ9gHZvAUqP6OQVecM2b8iqyaWPpObOcvtwe7BLvDKtchHzISYqvBzuiGIxNHl+ZbsWXCgZTB9P18PdM3dcSFvr21cdXA7YPMbUHVt/QTiYmDm+d1okLxOJ0iCHCmPycVg57t6dRat8awlMoUcYp6+E=
Message-ID: <47FCAEA3.5030004@gmail.com>
Date: Wed, 09 Apr 2008 13:55:15 +0200
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: linux-next: Tree for April 9
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au> <d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com> <20080409210936.ec8ea986.sfr@canb.auug.org.au> <20080409212719.7d834c13.sfr@canb.auug.org.au> <47FCA7FA.3010008@gmail.com> <20080409113439.GA26174@elte.hu>
In-Reply-To: <20080409113439.GA26174@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar pisze:
> * Jacek Luczak <difrost.kernel@gmail.com> wrote:
> 
>>> Don't worry about it, I found the problem.
>>>
>>> It seems that commit 883a9fc4e5d9b0701f15d4e5a23608f942104721 ("x86: 
>>> cleanup - rename VM_MASK to X86_VM_MASK") from the x86 tree seems to 
>>> have missed some places.
>> Yep, I did the same. You can find patch, which renames changes VM_MASK 
>> to X86_VM_MASK across all files in arch/x86/kernel, here: 
>> http://pin.if.uz.zgora.pl/~difrost/linux-next/09042008/
> 
> ah, that again comes from x86/for-akpm missing a patch that comes later 
> in x86/latest. I'll resort it.

X86_VM_MASK was already changed in one place in kernel/traps_32.c:
  arch/x86/kernel/traps_32.c:502:    if (regs->flags & X86_VM_MASK) {
and in mm/fault.c:
  if (regs->flags & (X86_EFLAGS_IF | X86_VM_MASK))

-Jacek
