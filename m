Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYCYNoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYCYNoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 09:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYCYNoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 09:44:16 -0400
Received: from vena.lwn.net ([206.168.112.25]:44484 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbYCYNoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 09:44:16 -0400
To: Junio C Hamano <gitster@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stern@rowland.harvard.edu,
       khali@linux-fr.org, mb@bu3sch.de, hmh@hmh.eng.br, david-b@pacbell.net,
       rpurdie@rpsys.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
       geert@linux-m68k.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 25 Mar 2008 01:52:58 PDT."
             <7vbq53mbh1.fsf@gitster.siamese.dyndns.org> 
Date: Tue, 25 Mar 2008 07:44:15 -0600
Message-ID: <14605.1206452655@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> wrote:

> Is it just me who feels this comment that says "in_atomic() is not a way
> to tell if we are in atomic reliably and cannot be used for such and such"
> very reader-unfriendly?  Ok, maybe the macro is not reliable and is not
> meant to be used for the purpose its name seems to suggest (at least to a
> non-kernel person).  An inevitable question is, then what is it good for?
> What's the right situation to use this macro?

The "right situation" would appear to be "you're deep in the mm code and
really know what you're doing."  It is not a useful way for code to
determine whether it's running in atomic context - as was discussed
elsewhere in the thread, that information really needs to be passed in
by the caller.
 
Look for more detail on LWN, probably later today :)

> I guess an additional comment "even if this says no, you could still be in
> atomic, but if this says yes, then you definitely are in atomic and cannot
> sleep" may help unconfuse a clueless reader like myself.

The point being that "you just *might* be in atomic context, where
sleeping would be a bad idea, but I can't tell you" really isn't all
that useful.  It's a trap which can only lead to incorrect code.

What really needs to happen, IMHO, is that this macro should be ripped
out of hardirq.h entirely and cleverly hidden somewhere.  That can't be
done, though, until the drivers which use it are fixed.  But while that
is happening, we can at least put up a skull-and-crossbones sign to
discourage others from making the same mistake.

jon
