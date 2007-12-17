Return-Path: <linux-kernel-owner+w=401wt.eu-S933390AbXLQIit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbXLQIit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 03:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbXLQIik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 03:38:40 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:33100 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbXLQIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 03:38:40 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Date: Mon, 17 Dec 2007 08:38:39 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <fk5cif$ru7$1@taverner.cs.berkeley.edu>
References: <47650A4C.4000708@davidnewall.com> <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp> <46595.81.207.0.53.1197823928.squirrel@secure.samage.net> <200712170642.lBH6gKNY069170@www262.sakura.ne.jp>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1197880719 28615 128.32.168.222 (17 Dec 2007 08:38:39 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 17 Dec 2007 08:38:39 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Wagner wrote:
> If the attacker gets full administrator-level access on your machine,
> there are a gazillion ways the attacker can prevent other admins from
> logging on. This patch can't prevent that.  It sounds like this patch
> is trying to solve a fundamentally unsolveable problem.

Tetsuo Handa wrote:
> Please be aware that I'm saying "if this filesystem is used with MAC".

I'm aware.  I'm sticking with my argument.

I doubt that any we're likely to see a MAC system that is strict enough
to prevent an attacker with administrator access from locking out other
admins, and is yet is loose enough to be useful in practice.  I think
the proposed patch is like sticking a thumb in the dike and is trying
to solve a problem that cannot be solved with any reasonable application
of effort.  I think if the attacker has gotten administrator level, then
we'll never be able to prevent the attacker from doing all sorts of bad
things we don't like, like locking out other admins.  Of course if we
have a proposed defense that only stops one particular attack pathway
but leaves dozens others open, it's always convenient to say that "the
other attack pathways aren't my problem, that's the MAC's business".
Sure, if we want to hypothesize the existence of a "magic fairy dust"
MAC system that somehow closes every other path via which admin-level
attackers could lock out other admins, except for this one pathway, then
this patch might make sense.  But I see no reason to expect ordinary
MAC systems to have that property.

Trying to put in place a defense that only prevents on particular attack
path, when there are a thousand other ways an attacker might achieve the
same ends, does not seem like a good way to go about securing your system.
For every one attack path that you shut down, the attacker can probably
think up a dozen new paths that you haven't shut down yet.  That isn't
a good basis for security.

Personally, I'd argue that we should learn a different lesson from
the attack you experienced.  The lesson is not "oh boy, we better shut
down this particular way that the attacker misused administrator-level
access".  I think a better lesson is "let's think about ways to reduce
the likelihood that attackers will get administrator-level access,
because once the attacker has administrator-level access, the attacker
can do a lot of harm".

>If MAC(such as SELinux, TOMOYO Linux) allows attackers to
>"mount other filesystem over this filesystem", this filesystem is no
>longer tamper-proof.
>But as long as MAC prevents attackers from mounting other filesystem
>over this filesystem,
>this filesystem can remain tamper-proof.

But the point is that it's not enough just to prevent attackers
from mounting other filesystems over this filesystem.  I can think
of all sorts of ways that an admin-level attacker might be able to
prevent other administrators from logging in.  If your defense strategy
involves trying to enumerate all of those possible ways and then shut
them down one by one, you're relying upon a defense strategy known as
"blacklisting".  Blacklisting has a terrible track record in the
security field, because it's too easy to overlook one pathway.
