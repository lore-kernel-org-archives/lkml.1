Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0BKDbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 22:31:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab0BKDa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 22:30:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 4/4] ptrace: Add support for generic	PTRACE_GETREGSET/PTRACE_SETREGSET
In-Reply-To: H. Peter Anvin's message of  Wednesday, 10 February 2010 18:17:03 -0800 <4B73689F.5090407@zytor.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	<20100209202502.406177090@sbs-t61.sc.intel.com>
	<20100210131826.GA21196@redhat.com>
	<20100210191240.DC9E4CC@magilla.sf.frob.com>
	<4B73689F.5090407@zytor.com>
X-Shopping-List: (1) Scientific rooster lotion
   (2) Charismatic hiders
   (3) Autonomous hair
   (4) Lunatic admonishers
Message-Id: <20100211033040.01F02D14@magilla.sf.frob.com>
Date: Wed, 10 Feb 2010 19:30:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Allowing a larger size for get seems very sane.  Allowing a smaller size
> would be ok iff we make sure we handle corner cases right (i.e. a
> partially overwritten subregister.)

It should enforce the static constraints of the user_regset, which include
a starting position that's 0 % .align (if we had non-zero starting position
in the request) and a size that's 0 % .size.  The arch code sets those and
then is not obliged to handle requests outside those constraints.  It's
already documented that the arch code is obliged to handle any partial
regset access that meets them.

The usual thing is to set .size and .align to the size of a register.
This is exactly so that the arch code does not need to add gratuitous
corner case complications such as "partially overwritten subregister".


Thanks,
Roland
