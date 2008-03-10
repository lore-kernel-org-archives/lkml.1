Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbYCJV0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbYCJV0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYCJV0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:26:43 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:34602 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYCJV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:26:43 -0400
From: Stephan Diestelhorst <langer_mann@web.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Date: Mon, 10 Mar 2008 22:26:38 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, davej@codemonkey.org.uk,
       cpufreq@lists.linux.org.uk, linux-kernel@vger.kernel.org
References: <200803051559.09962.langer_mann@web.de> <200803101605.42251.langer_mann@web.de> <87iqzu8r2q.fsf@basil.nowhere.org>
In-Reply-To: <87iqzu8r2q.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803102226.39044.langer_mann@web.de>
X-Provags-ID: V01U2FsdGVkX193Y+3z7CFfarIKWciEOWCONbvsn42L5IBKqlhu
	fH7Wc4Us9HRRuKmW9T8ENMWagRFFpL5TU2/Iho/RIomTnvnLp+
	Rj20LUQQA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Stephan Diestelhorst <langer_mann@web.de> writes:
> > 
> > New attempt with full clobbers, note that I deliberatly did not change
> > the order of the output registers. Real output operands still preceede
> > outputs used for potential clobbering.
> > 
> > I'm not too sure about the EBP push/pop frame, but as folks pointed
> > out already, we should not trust the SMI code too much.
> 
> Be careful -- older gcc versions tend to abort for inline asm
> that clobbers too many registers. Especially when the register
> is already used (like ebp in a frame pointer enabled kernel) 

AFAIK clobbering ebp is silently ignored on the GCCs I've tried it
on (regardles of frame-pointer ommission). Hence there is a hard-coded
push & pop for that register.

Please also note that these are not clobbers in the strict inline asm
syntax, but rather dummy output values that correspond to actual
input parameters. I'd consider this a serious compiler flaw, if not
bug, if these would not work. But let's not get into GCC vs.
Fancy-inline-asm-hacker flames, like the mplayer folks do ;-)

> Make sure it at least works on the oldest supported gcc version 
> (gcc 3.2) and with frame pointer on.

As I've said, I do not expect this to be problematic, but will test,
just to be sure! 

> For asms with so many clobbers explicit push/pop is usually safer.

Yes, but it is unneccessary overhead as the compiler can (should!)
find more elegant ways to get those registers back if needed.

Regards,
  Stephan
