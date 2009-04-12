Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZDLOCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZDLOCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZDLOCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:02:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbZDLOCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:02:39 -0400
Date: Sun, 12 Apr 2009 16:01:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avi Kivity <avi@redhat.com>, Pavel Machek <pavel@ucw.cz>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
       rjw@sisk.pl, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090412140149.GB5246@elte.hu>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz> <20090410103934.GA21506@elte.hu> <20090410104648.GA31516@elf.ucw.cz> <20090410112546.GD21506@elte.hu> <20090410113824.GA18823@elf.ucw.cz> <49E0C1AB.2050608@redhat.com> <49E17A6E.5000104@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E17A6E.5000104@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Avi Kivity wrote:
>>
>> kvm might help detecting these issues, but not in fixing them.  
>> If you isolate the BIOS, then you've prevented corruption, but 
>> you've also prevented it from doing whatever it is it was 
>> supposed to do.  If you give it access to memory and the rest of 
>> the system, then whatever evil it has wrought affects the system.
>>
>> You could try to allow the BIOS access to selected pieces of 
>> memory and hardware, virtualizing the rest, but it seems to me it 
>> would be more like a recipe for a giant headache that a solution.
>>
>
> The main thing you could do is drop or virtualize memory accesses 
> to RAM it should never access in the first place, like some BIOSes 
> which scribble over random locations in low memory.

it would be enough to get the information out. That way we could see 
(from the access patterns) what the heck it is trying to do (did 
someone rootkit the bios?), and what we can do about it. Trying to 
contain it will likely break the BIOS and causes silent hangs with 
no usable bug report left.

	Ingo
