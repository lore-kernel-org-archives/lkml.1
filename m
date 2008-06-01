Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYFAX4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYFAX4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 19:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYFAX4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 19:56:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:38956 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbYFAX4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:56:44 -0400
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, David Miller <davem@davemloft.net>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0806012221170.3235@apollo.tec.linutronix.de>
References: <20080529124548.GC8065@mit.edu>
	 <20080529.135431.235149338.davem@davemloft.net>
	 <20080529211404.GH8065@mit.edu>
	 <20080529.143921.34376298.davem@davemloft.net>
	 <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de>
	 <20080601181706.GB26477@srcf.ucam.org>
	 <alpine.LFD.1.10.0806012221170.3235@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 09:56:15 +1000
Message-Id: <1212364575.15633.115.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-01 at 22:22 +0200, Thomas Gleixner wrote:
> On Sun, 1 Jun 2008, Matthew Garrett wrote:
> 
> > On Sun, Jun 01, 2008 at 04:11:01PM +0200, Thomas Gleixner wrote:
> > 
> > > Fix NOHZ/CPUIDLE along with suspend/resume on all participants
> > > laptops, which are probably 50+ different models. That'd be an odd
> > > enough mix of wreckaged hardware / BIOS / ACPI.
> > 
> > If we have in-kernel video reinit for the major vendors by then, sure. 
> > If not, I suspect the majority of issues we'd hit would just be "My 
> > screen doesn't come back".
> 
> And why wouldn't it be a good idea to spend time on adding the video
> reinit right there at the hacking session ?

You mean adding the right sequence of whacking 200+ non documented chip
registers in the right order with the right values that have to be
subtly different on each revision and each OEM implementation ? :-)

At least for ATI, we do have the necessary infos to do it actually. We
can parse tables in the BIOS, we know how to, we have the format and the
necessary interpreter, it's mostly a matter of doing it (and
re-implementing the interpreter in code that is acceptable to the
kernel, last I looked, the one in X isn't).

For nVidia, it's harder though the "nouveau" folks do have figured how
to run some of the BIOS foo too (same thing, BIOS contains magic
"scripts" that can be interpreted to bootstrap the card).

For others (VIA, XGI, ...) I don't know.

Cheers,
Ben.


