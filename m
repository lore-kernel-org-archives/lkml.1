Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbXE1Pot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbXE1Pot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 11:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbXE1Poj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 11:44:39 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:43451
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbXE1Poi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 11:44:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Mon, 28 May 2007 17:43:31 +0200
User-Agent: KMail/1.9.6
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705281714.25841.mb@bu3sch.de> <1180366371.4952.5.camel@chaos>
In-Reply-To: <1180366371.4952.5.camel@chaos>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705281743.32134.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 May 2007 17:32:51 Thomas Gleixner wrote:
> On Mon, 2007-05-28 at 17:14 +0200, Michael Buesch wrote:
> > > The -oldconfig1 is the kernel that had no problems and the other shows the b44 
> > > problem. So if High Resolution Timer Support is disabled everything works 
> > > fine and if I enable it the problems do appear again.
> > > 
> > > I didn't test this on my 2.6.22-rc3 kernel yet, but I guess disabling High 
> > > Resolution Timer Support will also solve the problem there.
> > > 
> > > The older kernels I tried also work perfectly fine and they didn't have the 
> > > High Resolution Timer Support yet.
> > 
> > So, that's interesting, indeed.
> > Any idea what's going on, someone? Thomas?
> 
> Not off the top of my head.
> 
> Maximilian, does the kernel work otherwise (I mean aside of the b44
> driver) ? 
> 
> Can you please keep CONFIG_HIGH_RES_TIMERS and CONFIG_NOHZ and try the
> following combinations on the kernel command line:
> 
> 1) highres=off nohz=off (should be the same as your working config)
> 2) highres=off
> 3) nohz=off
> 
> Michael, is anything in the b44 driver timer driven ?

NAPI perhaps. I don't know. Steve may know.

The only timer in b44 is to update stats every second. I doubt
that this can cause such an issue. It's not involved in transmission.

-- 
Greetings Michael.
