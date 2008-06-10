Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYFJTGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYFJTGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753603AbYFJTF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:05:58 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:44562 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbYFJTF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:05:57 -0400
X-IronPort-AV: E=Sophos;i="4.27,618,1204531200"; 
   d="scan'208";a="55467301"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: MMIO and gcc re-ordering issue
References: <1211852026.3286.36.camel@pasglop>
	<alpine.LFD.1.10.0806031153360.3473@woody.linux-foundation.org>
	<200806101656.51211.nickpiggin@yahoo.com.au>
	<200806101041.28829.jbarnes@virtuousgeek.org>
	<1213121426.8536.7.camel@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 10 Jun 2008 12:05:55 -0700
In-Reply-To: <1213121426.8536.7.camel@localhost.localdomain> (James
	Bottomley's message of "Tue, 10 Jun 2008 13:10:26 -0500")
Message-ID: <adaskvl3yb0.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jun 2008 19:05:55.0433 (UTC) FILETIME=[0266FD90:01C8CB2D]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > me too.  That's the whole basis for readX_relaxed() and its cohorts: we
 > make our weirdest machines (like altix) conform to the x86 norm.  Then
 > where it really kills us we introduce additional semantics to selected
 > drivers that enable us to recover I/O speed on the abnormal platforms.

Except as I pointed out before, Altix doesn't conform to the norm and
many (most?) drivers are missing mmiowb()s that are needed for Altix.
Just no one has plugged most devices into an Altix (or haven't stressed
the driver in a way that exposes problems of IO ordering between CPUs).

It would be a great thing to use the powerpc trick of setting a flag
that is tested by spin_unlock()/mutex_unlock() and automatically doing
the mmiowb() if needed, and then killing off mmiowb() entirely.

 - R.
