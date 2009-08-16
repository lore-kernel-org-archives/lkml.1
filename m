Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZHPVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZHPVJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZHPVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 17:09:19 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:59523 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080AbZHPVJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 17:09:19 -0400
From: David Wagner <daw@cs.berkeley.edu>
Message-Id: <200908162109.n7GL9JNK029605@taverner.cs.berkeley.edu>
Subject: Re: Security: information leaks in /proc enable keystroke recovery
To: rwatson@FreeBSD.org (Robert Watson)
Date: Sun, 16 Aug 2009 14:09:19 -0700 (PDT)
Cc: oliver.pntr@gmail.com (Oliver Pinter), daw@cs.berkeley.edu (David Wagner),
       freebsd-hackers@FreeBSD.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.BSF.2.00.0908162014030.1901@fledge.watson.org> from "Robert Watson" at Aug 16, 2009 09:06:41 PM
Secret-Bounce-Tag: 9a029cbee41caf2ca77a77efa3c13981
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the comments.

> Beyond this, and assuming the correct implementation of the above,
> we're into the grounds of classic trusted OS covert channel analysis,
> against which no COTS UNIX OSes I'm aware of are hardened.  This isn't to
> dismiss these attacks as purely hypothetical -- we've seen some rather
> compelling examples of covert channels being exploited in unexpected
> and remarkably practical ways in the last few years (Steven Murdoch's
> "Hot or Not" paper takes the cake in that regard, I think).

To be pedantic, I'd say that the Usenix Security paper describes a side
channel, not a covert channel.  The paper shows how a malicious attacker
can attack an unsuspecting victim application.

Covert channels are when both the sender and the receiver are malicious
and cooperating to transmit information from the sender to the receiver.
In contrast, side channels arise when the "sender" is unintentionally
and inadvertently leaking information that can be decoded by a malicious
receiver, against the interests of the "sender".  The attack in the
paper is a side channel, not a covert channel.  When it comes to covert
channels, it is indeed reasonable to throw up your hands and say that
defending against covert channels is basically impossible, so why bother?
For side channels, though, it's less clear that this is a persuasive
argument.

I agree we certainly shouldn't discuss the keystroke recovery attack
as hypothetical, because it is clearly not hypothetical: the authors
implemented it and found that it works.

> However, this next step up from "the kernel doesn't reveal information on
> processes from other users" involves scheduler hardening, consideration
> of inter-CPU/core/thread cache interactions, and so on -- things that we
> don't have a good research, let alone production, OS understanding of.

Indeed.  A major challenge.  Good to hear that, in its default
configuration, FreeBSD does eliminate the attack vector described in
the Usenix Security paper (the EIP/ESP leak).  It seems a good starting
point would be to limit access to information that we know can enable
keystroke recovery -- as FreeBSD apparently already does, but Linux
apparently does not.
