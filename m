Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZBJLM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZBJLM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 06:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZBJLMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 06:12:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbZBJLMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 06:12:12 -0500
Date: Tue, 10 Feb 2009 12:11:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tejun Heo <tj@kernel.org>, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 08/11] x86: use asm .macro instead of cpp #define in
	entry_32.S
Message-ID: <20090210111154.GA7822@elte.hu>
References: <1234186798-16820-1-git-send-email-tj@kernel.org> <1234186798-16820-9-git-send-email-tj@kernel.org> <4990774E.5080206@goop.org> <4990D4E3.1010109@kernel.org> <4990D5F5.9030409@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4990D5F5.9030409@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Tejun Heo wrote:
>> Hmm... I originally did the conversion because I had some .if trick in
>> SAVE_ALL which got removed later.  Even after the removal, it
>> generally looked like a good idea as x86_64 asm was primarily using
>> .macro too.  I do like being able to see the post-processing output of
>> cpp too but for assembler disassembling the output often seem to give
>> enough clue,
>
> That's assuming that the file assembles.  But if you're trying to assemble
> and the best error the assembler comes up with is "bad operand" on the line
> where you're using the macro, its extremely frustrating trying to work out
> where the problem actually lies.

Yeah, i had that experience with GAS usability with all the CFI restructuring
we did.

But it should be pretty rare that we come up with instructions that do not
assemble - and even rarer that we come up with a _lot_ of new instructions
that do not assemble. The trick i used was to remove bits of the macro to
hone in on the bad instruction/construct. Stone-age tool but works.

	Ingo
