Return-Path: <linux-kernel-owner+w=401wt.eu-S1751142Ab0AKB3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab0AKB3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 20:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791Ab0AKB3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 20:29:44 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:38343 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab0AKB3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 20:29:44 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Date: Mon, 11 Jan 2010 01:29:43 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hiduu7$7cg$2@taverner.cs.berkeley.edu>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215848.GA26609@elf.ucw.cz>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1263173383 7568 128.32.153.193 (11 Jan 2010 01:29:43 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 11 Jan 2010 01:29:43 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek  wrote:
>Scenario 2:
>
>Mallory calls disablenetwork, calls sendmail as the first user after
>boot; sendmail can't deliver anything (its network is disabled), but
>starts forking and taking requests for other users, DoSing the mail
>delivery.

On my system, sendmail is started by trusted boot scripts before
a "Mallory" would have a chance to do that, so the premise does not
apply.  I cannot guarantee this is the case on every system, but I'm
not familiar with any important exceptions.

>Scenario 3:
>
>Mallory calls disablenetwork, then keeps hammering on su, knowing that
>su can no longer send data to audit subsystem and so he will not get caught.

And then what?  I don't see how this gets Mallory very far.
She can keep hammering on su and keep getting denied access to
root, and it's not going to help her much.

(Note: If root's password is guessable, then there's a fair chance you're
screwed even without disablenetwork.  If root has a guessable password,
then Mallory can keep trying until she guesses right, then when she
gets it right, go and retroactively edit the logs to eliminate the
log entries if necessary -- if those log entries are ever looked at,
which is often dubious.  It's very difficult to build a secure system
if the root password is guessable.  So in my opinion, the root password
must be unguessable if you want to have a secure system, and we should
analyze disablenetwork under the assumption that sysadmins have done so.
And if the system administrators do choose an unguessable password,
then your Scenario 3 doesn't seem to help Mallory.)

The impact here seems pretty minor.

>You can trivialy make disablenetwork disable setuid exec, too. That
>will introduce better isolation facilities, but not introduce any new
>security problems.

Yup, this is probably the compromise that must be made, for political
reasons, to get this into the kernel.

But I just want to document that it's not clear to me that this decision
is well justified on technical grounds.
