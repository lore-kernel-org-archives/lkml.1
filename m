Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbYCFLek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbYCFLek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 06:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYCFLed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 06:34:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbYCFLec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 06:34:32 -0500
Date: Thu, 6 Mar 2008 12:34:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix typo(?) in step.c
Message-ID: <20080306113413.GD17906@elte.hu>
References: <47CE69B0.76E4.0078.0@novell.com> <20080305134150.GA16477@elte.hu> <20080306075223.BA28B2700FD@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306075223.BA28B2700FD@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> The block-step test only tested that PTRACE_SINGLEBLOCK worked right. 
> I just souped it up to also test that PTRACE_SINGLESTEP still works 
> immediately afterwards.  This still does not show any problem from 
> this bug.  The case that would be broken by it is rather more arcane.  
> I haven't worked out the test case that fails with the bogon.

my interpretation of the bug would be that we fail to mask out the 
block-step MSR bit [because we mask out bit 25 instead of bit 1], and 
hence the bug would cause that MSR bit to stay enabled in other tasks 
too.

So in theory the bug should manifest itself as block-step mode never 
clearing itself, once activated. (but this would never leak into other 
tasks because we've got the thread.debugctlmsr abstraction that protects 
them)

	Ingo
