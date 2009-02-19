Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZBSVwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZBSVwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbZBSVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:52:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:60025 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758831AbZBSVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:51:59 -0500
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Collins <paul@burly.ondioline.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.p4D.L20jJB@chimera>
	 <878wognj00.fsf@burly.wgtn.ondioline.org> <200902142342.59186.rjw@sisk.pl>
	 <87hc2u26m5.fsf@burly.wgtn.ondioline.org>
	 <1234775410.26036.122.camel@pasglop>
	 <87d4di1wwr.fsf@burly.wgtn.ondioline.org>
	 <87r61uzv95.fsf@burly.wgtn.ondioline.org>
	 <1235032710.8805.37.camel@pasglop>
	 <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 08:51:43 +1100
Message-Id: <1235080303.8805.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 21:17 +0100, Thomas Gleixner wrote:
> 
> Well, harsh or not is not the question here. 
> 
> Fact is that you call gettimeofday() _before_ the timekeeping code has
> resumed.
> 
> That's a simple ordering problem. timekeeping is in the sysdev class
> as well and it's not the only sysdev which has explicit ordering
> requirements.

And how do I control that ordering ?

I find that a bit fishy ... What about making gettimeofday() in the
timekeeping code work, just return a frozen snapshot of the value on
suspend instead ?

Ben.


