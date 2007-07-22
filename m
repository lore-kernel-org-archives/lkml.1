Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbXGVTQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbXGVTQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbXGVTQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:16:33 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:33394 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXGVTQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:16:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=V0IXeOo4iYR+DVq8bsj9SCR3+9J60Km6pLfqNEAVIya0yEhf6B4QsjUve4iH6rQuJPFKyJ2tRC71vPEMUOdlESHwkF1/6CMYJhurDz5R1PuuyjpfJfh4w1+dLhUVZAOw;
Message-ID: <46A3AD07.1070504@simon.arlott.org.uk>
Date: Sun, 22 Jul 2007 20:16:23 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Eggert <eggert@CS.UCLA.EDU>
CC: Matthew Wilcox <matthew@wil.cx>, Denis Cheng <crquan@gmail.com>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       git@vger.kernel.org
Subject: Re: diffutils: C labels misdetected as functions
References: <1184489571313-git-send-email-crquan@gmail.com>	<4699EEA9.6070709@simon.arlott.org.uk>	<20070720170743.GF14791@parisc-linux.org>	<46A0F282.8070103@simon.arlott.org.uk>	<20070720180019.GJ14791@parisc-linux.org>	<46A1A375.3020900@simon.arlott.org.uk>	<20070721135200.GQ14791@parisc-linux.org>	<46A25BE0.7000104@simon.arlott.org.uk> <87abtogu6u.fsf@penguin.cs.ucla.edu>
In-Reply-To: <87abtogu6u.fsf@penguin.cs.ucla.edu>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/07 19:38, Paul Eggert wrote:
> Simon Arlott <simon@fire.lp0.eu> writes:
> 
>> The patch below stops diffutils treating C labels starting in column 1 as function names.
> 
> That patch alone wouldn't suffice, since -p is documented as implying
> -F '^[[:alpha:]$_]'.  If the behavior changes, we'd also have to
> change the documentation to match.

Ok.

> I'm not sure the change is a good idea.  It would complicate the
> documentation and therefore the user interface, without that much

Complicated documentation means a bug shouldn't be fixed?

> benefit.  And it wouldn't suffice in general, since it would still
> mishandle labels followed by comments or by white space.

Yes, the regexp needs changing further to ignore comments...

"[[:alpha:]$_][^:]*$" perhaps? Although that ignores functions with
comments on the same line containing a :.

> Also, for long C functions some people might rather see a top-level
> (unindented) label highlighted than the function name highlighted, so
> they might prefer the current behavior.

"-p  --show-c-function  Show which C function each change is in."

It's not "--show-c-function-or-label".

> Anyway, to work around your problem without changing "diff", you can
> use "diff -u -F '^[[:alpha:]$_](|.*[^:])$'" instead of "diff -u -p".

Perhaps git could do this (or similar) as a workaround? (Cc:ed)

> Or you can put a single space before the labels in question: they'll
> still stand out plenty.

The code should definitely not need to be modified to work around a
diff bug.

-- 
Simon Arlott
