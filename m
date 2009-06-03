Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZFCHSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZFCHSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZFCHSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:18:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbZFCHSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:18:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, paul@mad-scientist.net,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
In-Reply-To: Oleg Nesterov's message of  Tuesday, 2 June 2009 17:29:44 +0200 <20090602152927.GA13515@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet>
	<20090531111851.07eb1df3@lxorguk.ukuu.org.uk>
	<20090601161234.GA10486@redhat.com>
	<20090601174159.48acf3f5@lxorguk.ukuu.org.uk>
	<20090601171119.GA13970@redhat.com>
	<20090601184608.6379440c@lxorguk.ukuu.org.uk>
	<20090601182305.GA16372@redhat.com>
	<20090601203845.B010DFC3C7@magilla.sf.frob.com>
	<20090601223241.GA26788@redhat.com>
	<20090602092119.1a12a356@lxorguk.ukuu.org.uk>
	<20090602152927.GA13515@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20090603071545.DFDA0FC333@magilla.sf.frob.com>
Date: Wed,  3 Jun 2009 00:15:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm. Does ->core_dump() report the state of ->sighand->action? I can't
> find any usage. Perhaps we can just ignore all signals except SIGKILL ?

I don't think anything uses that information.  But it might one day,
or it might matter in some other arcane way (/proc/pid/status during
the dump is the only way I can think of to notice, but who knows).

I think it's better just not to get into any kludges that clobber
anything that records actual user-visible state that we normally
read out to userland in any fashion (even if none is known to do so
at dumping time or later).  It's much more natural just to use pure
internal kernel state such as signal->flags for anything like this.


Thanks,
Roland
