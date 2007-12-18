Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbXLRFNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbXLRFNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 00:13:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbXLRFNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 00:13:35 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3768 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXLRFNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 00:13:34 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Theodore Tso" <tytso@mit.edu>, "John Reiser" <jreiser@BitWagon.com>,
       "Matt Mackall" <mpm@selenic.com>, <linux-kernel@vger.kernel.org>,
       <security@kernel.org>
Subject: RE: /dev/urandom uses uninit bytes, leaks user data
Date: Mon, 17 Dec 2007 21:12:56 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEPIIOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <476719E5.1010505@myrealbox.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 17 Dec 2007 21:14:05 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 17 Dec 2007 21:14:07 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Has anyone *proven* that using uninitialized data this way is safe?

You can probably find dozens of things in the Linux kernel that have not
been proven to be safe. That means nothing.

> As
> a *user* of this stuff, I'm *very* hesitant to trust Linux's RNG when I
> hear things like this.  (Hint: most protocols are considered insecure
> until proven otherwise, not the other way around.)

There's no reason whatsoever to think this is unsafe. First, you can't
access the pool directly. Second, even if you could, it's mixed in securely.

> Now imagine a security program.  It runs some forward secret protocol
> and it's very safe not to leak data that would break forward secrecy
> (mlockall, memset when done with stuff, etc).  It runs on a freshly
> booted machine (no DSA involved, so we're not automatically hosed), so
> an attacker knows the initial pool state.  Conveniently, some *secret*
> (say an ephemeral key, or, worse, a password) gets mixed in to the pool.
>   There are apparently at most three bytes of extra data mixed in, but
> suppose the attacker knows add the words that were supposed to get mixed
> in.  Now the program clears all its state to "ensure" forward secrecy,
> and *then* the machine gets hacked.  Now the attacker can learn (with at
> most 2^24 guesses worth of computation) 24 bits worth of a secret, which
> could quite easily reduce the work involved in breaking whatever forward
> secret protocol was involved from intractable to somewhat easy.  Or it
> could leak three bytes of password.  Or whatever.

This is no more precise than "imagine there's some vulnerability in the
RNG". Yes, if there's a vulnerability, then we're vulnerable.

An attacker can always (at least in principle) get the pool out of the
kernel. The RNG's design is premised on the notion that it is
computationally infeasbile to get the input entropy out of the pool. If an
attacker can watch data going into the pool, he needn't get it out of the
pool.

> Sorry for the somewhat inflammatory email, but this is absurd.

I agree.

DS


