Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZBVUrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZBVUrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 15:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbZBVUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 15:47:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:44822 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZBVUrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 15:47:14 -0500
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Collins <paul@burly.ondioline.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902222026410.3523@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.p4D.L20jJB@chimera>
	 <878wognj00.fsf@burly.wgtn.ondioline.org> <200902142342.59186.rjw@sisk.pl>
	 <87hc2u26m5.fsf@burly.wgtn.ondioline.org>
	 <1234775410.26036.122.camel@pasglop>
	 <87d4di1wwr.fsf@burly.wgtn.ondioline.org>
	 <87r61uzv95.fsf@burly.wgtn.ondioline.org>
	 <1235032710.8805.37.camel@pasglop>
	 <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain>
	 <1235080303.8805.50.camel@pasglop>
	 <alpine.LFD.2.00.0902222026410.3523@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 07:46:32 +1100
Message-Id: <1235335592.8805.214.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-22 at 20:31 +0100, Thomas Gleixner wrote:
> We had problems in the past where we just returned frozen time and the
> calling code got surprised when the time jumped 5 hours ahead just a
> few microseconds later.
> 
> What I find more fishy is the fact that the lid switch needs to be a
> sysdev. It's a simple input event, which causes the user space code to
> trigger the suspend sequence when the lid is shut.
> 
Well, the PMU is a sysdev for lots of good reasons.. then it -also-
happens to provide us with the lid switch event.

I'm a bit surprised by the explanation about the code that is surprised
to see the time jump. IE. Code -will- see the time jump anyway. IE. I
don't see how making gtod blow instead of returning a frozen time will
make any difference whatsoever for code who get the time some time
before suspend and then some time after resume and see a 5 hours gap...

Cheers,
Ben.


