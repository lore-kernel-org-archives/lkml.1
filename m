Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYABIka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYABIka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 03:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYABIkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 03:40:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbYABIkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 03:40:20 -0500
Date: Wed, 2 Jan 2008 09:40:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Miguel =?iso-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>
Cc: Matthew <jackdachef@gmail.com>, linux-kernel@vger.kernel.org,
       roland@redhat.com, tglx@linutronix.de
Subject: Re: Fwd: laptop / computer hardlocks during execution of 32bit
	applications(binaries) on 64bit system (Gentoo)
Message-ID: <20080102084002.GA13636@elte.hu>
References: <e85b9d30712291157v113f5e73yd830ae3c3429092d@mail.gmail.com> <e85b9d30712291504r2f4ef991w33f501ccf0d41c2b@mail.gmail.com> <200712300128.35476.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200712300128.35476.mboton@gmail.com>
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


* Miguel Botón <mboton.lkml@gmail.com> wrote:

> These hardlocks start to appear with commit 
> f10c1cfd359660c01446807b6c2bc8ce3aee919a

thanks, that's really useful! I dont see anything obviously wrong with 
the commit though, and cannot (yet) reproduce it, so to help us track it 
down further, could you try to figure out the lockup site? Does the NMI 
watchdog work on your box?

if the NMI watchdog does not work, can you reproduce it on a VGA 
console? If yes, then running the app that does the hard lockup via 
"strace -f <app>" could perhaps show us the last system call that 
happened before the box locked up. If we are lucky it's something 
specific.

here's the guilty commit from latest x86.git#mm:

  commit 81376371f1ca371de54aa4488edc541580d95a01
  Author: Roland McGrath <roland@redhat.com>
  Date:   Tue Jan 1 21:55:28 2008 +0100

      x86 i387 user_regset

	Ingo
