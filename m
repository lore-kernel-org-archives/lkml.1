Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZL3HYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZL3HYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 02:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbZL3HYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 02:24:16 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:36498 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbZL3HYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 02:24:12 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: RFC: disablenetwork facility. (v4)
Date: Wed, 30 Dec 2009 07:24:11 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhev6r$n8b$1@taverner.cs.berkeley.edu>
References: <20091229050114.GC14362@heat> <m1y6km11lj.fsf@fess.ebiederm.org>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262157851 23819 128.32.153.193 (30 Dec 2009 07:24:11 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Wed, 30 Dec 2009 07:24:11 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>The problem with the disable_network semantics you want
>is that they allow you to perform a denial of service attack
>on privileged users.  An unprivileged DOS attack is unsuitable
>for a general purpose feature in a general purpose kernel.

I'm not persuaded yet.

When you talk about DOS, let's be a bit more precise.  disablenetwork
gives a way to deny setuid programs access to the network.  It's not a
general-purpose DOS; it's denying access to the network only.  And the
network is fundamentally unreliable.  No security-critical mechanism
should be relying upon the availability of the network.

There are already a number of ways to deny service to the network.
Let me list a few:
  * Limit the number of open file descriptors using rlimit,
    open lots of file descriptors, and exec a setuid program.
  * Flood the local network link.
  * DOS the DNS servers (likely causing most connections to fail).
If there is a setuid-root program that fails catastrophically when the
network is unavailable, you've already got a serious problem -- and that
is true whether or not we introduce the disablenetwork service.

So while I certainly can't rule out the possibility that disablenetwork
might introduce minor issues, I think there are fundamental reasons to
be skeptical that disablenetwork will introduce serious new security
problems.
