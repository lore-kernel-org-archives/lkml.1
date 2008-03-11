Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYCKDoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYCKDoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 23:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbYCKDoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 23:44:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbYCKDoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 23:44:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Jan Beulich" <jbeulich@novell.com>
X-Fcc: ~/Mail/linus
Cc: "Ingo Molnar" <mingo@elte.hu>, <markus.t.metzger@intel.com>,
       <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix typo(?) in step.c
In-Reply-To: Jan Beulich's message of  Monday, 10 March 2008 11:53:19 +0000 <47D52F3F.76E4.0078.0@novell.com>
References: <47CE69B0.76E4.0078.0@novell.com>
	<20080305134150.GA16477@elte.hu>
	<20080306075223.BA28B2700FD@magilla.localdomain>
	<20080306112819.GC17906@elte.hu>
	<20080306120309.E4BE52700FD@magilla.localdomain>
	<20080306131119.GC21359@elte.hu>
	<47D52F3F.76E4.0078.0@novell.com>
X-Zippy-Says: Oh my GOD -- the SUN just fell into YANKEE STADIUM!!
Message-Id: <20080311034408.4F1A226F991@magilla.localdomain>
Date: Mon, 10 Mar 2008 20:44:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, is this going to be fully reverted, or is it worth pointing out/fixing
> other issues? The thing I'm recognizing right now is that
> eee3af4a2c83a97fff107ddc445d9df6fded9ce4 made the writes to
> DebugCtlMSR unconditional, which means any attempt to do
> debugging on i[345]86 will ultimately cause the kernel to oops. All of
> that stuff should really depend on CONFIG_X86_DEBUGCTLMSR...

I think it would be wise to excise all the BTS-related additions until
after 2.6.25.  But I am too swamped already and not planning to do
anything about this myself.  But, that said, FWIW it does not look to
me like debugctlmsr will ever be written on hardware that doesn't
support it.  The stores are all only enabled if TIF_DEBUGCTLMSR gets
set and thread.debugctlmsr is nonzero.  That can't be set by ptrace
unless arch_has_block_step() returns true.


Thanks,
Roland
