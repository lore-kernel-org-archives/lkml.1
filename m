Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYANI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYANI2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYANI1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:27:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42525 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbYANI1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:27:49 -0500
Date: Mon, 14 Jan 2008 09:27:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mboton@gmail.com" <mboton@gmail.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] x86: fix ioport unification on 32-bit [was: Re:
	hwclock failure in x86.git]
Message-ID: <20080114082725.GD18296@elte.hu>
References: <4786AA11.5010805@gmail.com> <4786AB1B.4030004@zytor.com> <4786AF4C.6050509@gmail.com> <4786C2CF.4070204@zytor.com> <20080110220444.4c9efdec.kjwinchester@gmail.com> <20080111140346.GA13604@elte.hu> <20080112010443.GA5476@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112010443.GA5476@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > thanks for tracking it down. I pulled that commit for now. But it would 
> > be nice to figure out what's going on there.
> 
> Zach was right. The unification was broken for 32-bit; it was missing 
> the actual pushf/popf EFLAGS manipluation (set_iopl_mask()) and 
> would've broken task switching between processes w/ different iopl in 
> paravirt guests too.  64-bit sys_iopl just does pt_regs->flags 
> modification and lets syscall/sysret plus ptregscall sync and do 
> EFLAGS update.
> 
> Also, use of volatile looks like leftover cruft.
> 
> This patch in on top of Miguel's (can respin to standalone if that's 
> better). [...]

thanks, applied.

	Ingo
