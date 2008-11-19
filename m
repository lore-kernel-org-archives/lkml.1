Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYKRX42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYKRX42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 18:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYKRX4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 18:56:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50599 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYKRX4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:56:18 -0500
Date: Wed, 19 Nov 2008 01:06:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <jbeulich@novell.com>, heukelum@fastmail.fm,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Glauber Costa <gcosta@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC,v2] x86_64: save_args out of line
Message-ID: <20081119000605.GQ6703@one.firstfloor.org>
References: <20081117175232.GA13766@mailshack.com> <49228648.76E4.0078.0@novell.com> <20081118111633.GA21036@mailshack.com> <4922C863.76E4.0078.0@novell.com> <20081118140349.GC23479@elte.hu> <4922E4D4.76E4.0078.0@novell.com> <20081118150024.GD30358@elte.hu> <20081118225336.60FFA1544EB@magilla.localdomain> <20081118233552.GP6703@one.firstfloor.org> <20081118234511.80C4F1544F1@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118234511.80C4F1544F1@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 03:45:11PM -0800, Roland McGrath wrote:
> Yes, I mean a single macro that produces both the instruction and the CFI
> pseudo-op to go with it.  This is the essential characteristic that makes
> it an improvement for maintaining the code.  The main problem we have now
> is that it's easy to write/modify plain assembly instructions and forget to
> add or update the CFI to match.  A well-considered set of macros can solve
> this without making it any harder for the average assembly programmer to
> understand what each line of the source means intuitively.

Hmm, but if the assembler cannot auto generate it how should the assembler
writer know if he should use the macro or the direct instruction without
understanding CFI?

Also what will the assembler reader do? Do they first have to understand
CFI to understand everything? I personally would probably just
resort to objdump -S in this situation.

I think you're saying that for the user the macros would be just
equivalent, but if that's true they could be just auto generated 
by the assembler. But it's obviously not, so you'll end up
with the Linux magic asm dialect (and its maintenance disadvantages)
and you'll still require CFI knowledge to understand/write everything 
anyways.

-Andi
