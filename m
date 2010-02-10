Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0BJBcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:32:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab0BJBct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:32:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 3/4] x86, ptrace: prepare regset get/set routines for user specified lengths
In-Reply-To: Suresh Siddha's message of  Tuesday, 9 February 2010 12:13:12 -0800 <20100209202502.310242237@sbs-t61.sc.intel.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.310242237@sbs-t61.sc.intel.com>
X-Shopping-List: (1) Wondrous insolent concussions
   (2) Gregarious lotion immunizations
   (3) Adamant complicators
   (4) Geopolitical admonishers
   (5) Cynical populous harmonizers
Message-Id: <20100210013224.DC3441C5@magilla.sf.frob.com>
Date: Tue,  9 Feb 2010 17:32:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is unnecessary and IMHO misguided.  The arch user_regset.get
and user_regset.set functions are not required to worry about bogus
arguments.  Their callers are required to pass values that don't violate
the .n, .size, and .align constraints in the user_regset.  The right place
to enforce these constraints on parameters coming from userland is in the
arch-independent code that calls the arch user_regset functions.


Thanks,
Roland
