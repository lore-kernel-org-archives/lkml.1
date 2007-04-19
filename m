Return-Path: <linux-kernel-owner+w=401wt.eu-S965254AbXDSVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965254AbXDSVBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766985AbXDSVBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:01:35 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:39236 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbXDSVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:01:34 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Thu, 19 Apr 2007 20:54:18 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f08ktq$c88$2@taverner.cs.berkeley.edu>
References: <20070416213350.GB4030@suse.de> <1176822230.3366.65.camel@localhost.localdomain> <462553A9.70504@novell.com> <1177005419.27654.157.camel@moss-spartans.epoch.ncsc.mil>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1177016058 12552 128.32.168.222 (19 Apr 2007 20:54:18 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Thu, 19 Apr 2007 20:54:18 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley  wrote:
>Integrity protection requires information flow control; you can't
>protect a high integrity process from being corrupted by a low integrity
>process if you don't control the flow of information.  Plenty of attacks
>take the form of a untrusted process injecting data that will ultimately
>be used by a more trusted process with a surprising side effect.

I don't agree with this blanket statement.  In a number of cases
of practical interest, useful integrity protection can be achieved
without full information flow control.  Suppose you have a malicious
("low integrity") process A, and a target ("high integrity") process B.
We want to prevent A from attacking B.  One way to do that is to ensure
that A has no overt channel it can use to attack process B, by severely
restricting A's ability to cause side effects on the rest of the world.
This is often sufficient to contain the damage that A can do.

Of course, if the intended functionality of the system requires A to
communicate data to B, and if you don't trust B's ability to handle
that data carefully enough, and if A is malicious, then you've got a
serious problem.

But in a number of cases (enough cases to be useful), you can provide
a useful level of security without needing information flow control and
without needing global, persistent labels.
