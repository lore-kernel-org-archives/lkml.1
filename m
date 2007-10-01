Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbXJAUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbXJAUoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbXJAUoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:44:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42432 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbXJAUoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:44:09 -0400
Subject: Re: [HACK] convert i_alloc_sem for direct_io.c craziness!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zach Brown <zach.brown@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, mingo@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20071001195256.GB7718@mami.zabbo.net>
References: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
	 <20071001195256.GB7718@mami.zabbo.net>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 22:39:16 +0200
Message-Id: <1191271156.5574.9.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-01 at 12:52 -0700, Zach Brown wrote:

> Do you have any suggestions for locking constructs that RT would prefer?

Basically, anything that maps to a simple mutex. Anything more complex
gets real messy real quick.

Locks that have non-exclusive states become non-deterministic because an
unbounded number of contexts can be in this state. Hence acquisition of
the exclusive state has unbounded time. Even when limited to a bounded
number, the ramifications to the PI graph will get you a head-ache.

Also, non-owner locks, ie. semaphores (asymetric acquisition vs release
contexts) are unusable because the lack of ownership undermines PI - who
to boost?


