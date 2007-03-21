Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbXCUN5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbXCUN5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXCUN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:57:11 -0400
Received: from www.osadl.org ([213.239.205.134]:48142 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbXCUN5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:57:11 -0400
Subject: Re: [PATCH] clockevents: Fix suspend/resume to disk hangs
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Marcus Better <marcus@better.se>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
In-Reply-To: <eto9sh$262$1@sea.gmane.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <200703162134.14265.rjw@sisk.pl>
	 <1174078066.13341.279.camel@localhost.localdomain>
	 <1174087552.13341.332.camel@localhost.localdomain>
	 <eto9sh$262$1@sea.gmane.org>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 15:04:22 +0100
Message-Id: <1174485863.10840.80.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 10:35 +0100, Marcus Better wrote:
> Thomas Gleixner wrote:
> 
> > I finally found a dual core box, which survives suspend/resume without
> > crashing in the middle of nowhere. Sigh, I never figured out from the
> > code and the bug reports what's going on.
> > 
> > The observed hangs are caused by a stale state transition of the clock
> > event devices, which keeps the RCU synchronization away from completion,
> > when the non boot CPU is brought back up.
> 
> This didn't fix the suspend problems on my Thinkpad R60. (Sorry for
> nagging - please let me know if I can assist in debugging this...)

I did not expect that it fixes your problem. clockevents are only used
in arch/i386 right now. You are running a 64 bit kernel, so a change of
your problem would have been very surprising.

You said, that the breakage came between 2.6.20 and rc2. Can you bisect
it ?

	tglx


