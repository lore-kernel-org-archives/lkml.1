Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYAIPW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYAIPW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYAIPWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:22:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38905 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbYAIPWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:22:21 -0500
Date: Wed, 9 Jan 2008 16:22:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: More breakage in native_rdtsc out of line in git-x86
Message-ID: <20080109152208.GA21280@elte.hu>
References: <20080109035534.GA30321@basil.nowhere.org> <20080109090956.GA14274@elte.hu> <20080109141908.GB12855@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109141908.GB12855@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > nope, it's a 64-bit setup/dependency bug/problem: the vsyscall mappings 
> > are installed via an __initcall, and that's too late for early use. The 
> > combo patch below fixed the crash for me, does it work on your box too?
> 
> That gives
> 
> /home/lsrc/quilt/linux/arch/x86/kernel/setup_64.c: In function 'setup_arch':
> /home/lsrc/quilt/linux/arch/x86/kernel/setup_64.c:468: error: implicit declarati
> on of function 'map_vsyscall'

i guess you have an old repository.

> But after I add a prototype to vsyscall.h it seems to work.
> 
> Just the barriers are still broken [...]

since yesterday there's a full barrier around rdtsc.

	Ingo
