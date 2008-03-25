Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYCYK4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYCYK4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbYCYK4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:56:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49677 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbYCYK4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:56:10 -0400
Date: Tue, 25 Mar 2008 11:56:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH FIXED] x86: only enable interrupts when kernel state
	has been set up
Message-ID: <20080325105559.GA3729@elte.hu>
References: <47E83C99.3040800@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E83C99.3040800@goop.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0022]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> The sysenter path tries to enable interrupts immediately.  
> Unfortunately this doesn't work in a paravirt environment, because not 
> enough kernel state has been set up at that point (namely, pointing 
> %fs to the kernel percpu data segment).  To fix this, defer 
> ENABLE_INTERRUPTS until after the kernel state has been set up.
>
> Unfortunately this means that we're running with interrupts disabled 
> for a while without calling the IRQ tracing code, but that can't be 
> called without setting up %fs either.
>
> [ Fix since last posting: make sure saved eflags has interrupts 
> enabled. ]

thanks Jeremy - will give it a shot.

	Ingo
