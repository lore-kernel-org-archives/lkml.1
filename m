Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYCWTGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYCWTGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYCWTGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:06:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41072 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbYCWTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:06:34 -0400
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080323184427.GA6691@joi>
References: <20080302185935.GA6100@joi> <1204485071.6240.56.camel@lappy>
	 <20080302194748.GA6005@joi> <1204487917.6240.64.camel@lappy>
	 <20080323154416.GA6817@joi> <1206287670.6437.113.camel@lappy>
	 <20080323184427.GA6691@joi>
Content-Type: text/plain
Date: Sun, 23 Mar 2008 20:06:08 +0100
Message-Id: <1206299168.6437.119.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 19:46 +0100, Marcin Slusarz wrote:

> 4 different lockups:
> http://alan.umcs.lublin.pl/~mslusarz/kernel/2008.03.23-lockup/ 

Brilliant, these are extremely helpful.

What seems to happen is a classic xtime deadlock, doing a xtime
seq_readlock while holding a seq_writelock.

Only need to figure out _why_ that is happening....

> Are there any downsides of using nmi_watchdog=2 all the time?

Some machines are said to not boot due to NMIs, hence the default is
off, but afaik, _if_ it works there are no downsides aside from the
slight NMI handling overhead.

> ps: Documentation/nmi_watchdog.txt says: "Currently, local APIC mode
> (nmi_watchdog=2) does not work on x86-64.". It's not true, so maybe someone
> should update this file?

Care to send a patch to the x86 maintainers? :-)

