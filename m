Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbXFVIdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbXFVIdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 04:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXFVIdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 04:33:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60740 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbXFVIdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 04:33:35 -0400
Date: Fri, 22 Jun 2007 10:33:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: [PATCH -rt] CONFIG_PARAVIRT and CONFIG_MCOUNT don't play well
	together
Message-ID: <20070622083330.GB19382@elte.hu>
References: <20070622080634.GP3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622080634.GP3723@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> Current -rt is broken when compiling with CONFIG_PARAVIRT and 
> CONFIG_MCOUNT both enabled.  Because CONFIG_MCOUNT disables 
> CONFIG_REGPARM, the calling convention must once again be explicit 
> with fastcall.  However, this was only half-way addressed in the -rt 
> patch (adding fastcall back to paravirt_ops function ptr declaration 
> but not the actual function definitions) so the compiled kernel has 
> caller putting stuff in registers and callee pulling things from the 
> stack. Impressive how far into boot it can get despite that ;-) Thanks 
> to Steven Rostedt for prodding me and starting the initial debugging.

thanks! I ran into this before and asked for the fastcalls to not be 
removed from upstream paravirt.c but to no avail it seems. It does no 
harm to anyone to keep the 'fastcall' declarations and definitions for 
places where _actual assembly code_ depends on the calling convention. 
Could someone please send this upstream-wards too?

	Ingo
