Return-Path: <linux-kernel-owner+w=401wt.eu-S1752570Ab0ABGX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0ABGX0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 01:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476Ab0ABGXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 01:23:25 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:50910 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0ABGXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 01:23:24 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Date: Sat, 2 Jan 2010 06:23:24 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhmoos$vnu$1@taverner.cs.berkeley.edu>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org> <20091231170641.6dd46c6e@lxorguk.ukuu.org.uk> <hhioif$j9t$3@taverner.cs.berkeley.edu> <20100101144629.54fe6cb6@lxorguk.ukuu.org.uk>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262413404 32510 128.32.153.193 (2 Jan 2010 06:23:24 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sat, 2 Jan 2010 06:23:24 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox  wrote:
>daw@cs.berkeley.edu (David Wagner) wrote:
>> You lost me there.  The ability of a specific piece of code to voluntarily
>> relinquish privileges can be a big benefit to security. 
>
>Can be - but its historically been an endless source of bugs and flaws
>because the code being run after you take the rights away is being run in
>an environment it didn't expect and wasn't tested in.

Are you just *shrugging* at the goals underlying these efforts?
The goals of enabling privilege separation and sandboxing seem like
highly laudable goals to me.  I don't understand why anyone would
be opposed to efforts to achieve those goals.

Privilege-separation is a powerful software architecture technique.
It's been used in openssh, qmail, vsftpd, and other highly regarded
security-critical applications.  (When a software designer uses privilege
separation, he *intends* for his code to be run in a low-privilege
environment.  That's not a source of bugs.)

Sandboxing is a powerful security tool.  It's been used for many
purposes.  (When we invent a sandboxing tool, the whole purpose is
to run the sandboxed code to run in a low-privilege environment.)

There is indeed one undesired source of bugs sometimes introduced by
privilege-separation and sandboxing tools, and that is an increased
potential for attacks against setuid programs by local users.  But calling
this "an endless source of bugs and flaws" seems over the top to me.
How many examples have there been?  I can think of one of any significance
(sendmail).  In any case, I would classify these flaws as inherently
relatively low-severity, because they can only be exploited by local
users.

I'm far more concerned about attacks by remote attackers.  I don't
let untrusted people have accounts on my system.  So I really am not
that concerned about ways that a local user might try to attack
setuid root programs.  But I am quite concerned about remote exploits.
And privilege separation and sandboxing are two of the best techniques
we have available to defend against remote exploits.

To do that, application developers need better mechanisms to enable
them to voluntarily and irrevocably relinquish privilege.  That seems
like a worthwhile goal, and something that ought to be attainable without
introducing much risk of opening up new ways of attacking setuid programs.
(Indeed, there have been a number of proposals for how to achieve that
here on linux-kernel in the past few days.)  So why are you pushing back
against that goal?  Why are you so critical even of reasonable attempts
to provide a way to achieve the benefits without enabling those kinds
of attacks on setuid programs?  What am I missing?

Perhaps I'm reading you wrong, but I seem to sense an attitude where you
consider privilege separation and sandboxing to be relatively unimportant,
and where you consider the risk of local attacks on setuid programs to
be unavoidable and of paramount importance.  I'm surprised to get this
impression, because that seems narrow and counter-productive to me.
