Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZBVTcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZBVTcp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 14:32:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZBVTcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 14:32:36 -0500
Received: from www.tglx.de ([62.245.132.106]:53034 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZBVTcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 14:32:35 -0500
Date: Sun, 22 Feb 2009 20:31:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Paul Collins <paul@burly.ondioline.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12667] Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
In-Reply-To: <1235080303.8805.50.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902222026410.3523@localhost.localdomain>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>  <sWhNs83kKPE.A.p4D.L20jJB@chimera>  <878wognj00.fsf@burly.wgtn.ondioline.org> <200902142342.59186.rjw@sisk.pl>  <87hc2u26m5.fsf@burly.wgtn.ondioline.org>  <1234775410.26036.122.camel@pasglop> 
 <87d4di1wwr.fsf@burly.wgtn.ondioline.org>  <87r61uzv95.fsf@burly.wgtn.ondioline.org>  <1235032710.8805.37.camel@pasglop>  <alpine.LFD.2.00.0902192114150.3523@localhost.localdomain> <1235080303.8805.50.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009, Benjamin Herrenschmidt wrote:
> On Thu, 2009-02-19 at 21:17 +0100, Thomas Gleixner wrote:
> > 
> > Well, harsh or not is not the question here. 
> > 
> > Fact is that you call gettimeofday() _before_ the timekeeping code has
> > resumed.
> > 
> > That's a simple ordering problem. timekeeping is in the sysdev class
> > as well and it's not the only sysdev which has explicit ordering
> > requirements.
> 
> And how do I control that ordering ?
> 
> I find that a bit fishy ... What about making gettimeofday() in the
> timekeeping code work, just return a frozen snapshot of the value on
> suspend instead ?

We had problems in the past where we just returned frozen time and the
calling code got surprised when the time jumped 5 hours ahead just a
few microseconds later.

What I find more fishy is the fact that the lid switch needs to be a
sysdev. It's a simple input event, which causes the user space code to
trigger the suspend sequence when the lid is shut.

Thanks,

	tglx

