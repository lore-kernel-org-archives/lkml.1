Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXGaGbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXGaGbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbXGaGbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:31:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41764 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXGaGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:31:16 -0400
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
From: Peter Zijlstra <peterz@infradead.org>
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
In-Reply-To: <1185839164.27166.7.camel@localhost>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	 <1185536610.502.8.camel@localhost>  <20070729170641.GA26220@elte.hu>
	 <1185839164.27166.7.camel@localhost>
Content-Type: text/plain
Date: Tue, 31 Jul 2007 08:31:01 +0200
Message-Id: <1185863461.3092.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 01:46 +0200, Kasper Sandberg wrote:

> could perhaps be filesystem related, i have my maildir(extremely large)
> on reiserfs, and /home on xfs. what my mail client will do is download
> mail, spamasassin it(loading database from home), then it will put to
> imap server placing it on reiserfs, and then a "local" copy in my home.

Ooh, do you perchance have PREEMPT_BKL=y? 

If so, try on another filesystem than reiserfs (or disable PREEMPT_BKL,
but that is obviously the lesser of the two choices).

Ingo traced a 1+ second latency at my end to BKL priority inversion
between tty and reiserfs.

