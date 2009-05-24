Return-Path: <linux-kernel-owner+w=401wt.eu-S1758370AbZEXWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370AbZEXWz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZEXWzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 18:55:47 -0400
Received: from smtp.knology.net ([24.214.63.101]:45760 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791AbZEXWzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 18:55:46 -0400
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
From: David Dillow <dave@thedillows.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael =?ISO-8859-1?Q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20090524211557.GA14634@electric-eye.fr.zoreil.com>
References: <1242001754.4093.12.camel@obelisk.thedillows.org>
	 <200905112248.44868.mb@bu3sch.de> <200905112310.08534.mb@bu3sch.de>
	 <1242077392.3716.15.camel@lap75545.ornl.gov>
	 <4A09DC3E.2080807@googlemail.com>
	 <1242268709.4979.7.camel@obelisk.thedillows.org>
	 <4A0C6504.8000704@googlemail.com>
	 <1242328457.32579.12.camel@lap75545.ornl.gov>
	 <4A0C7443.1010000@googlemail.com>
	 <1243042174.3580.23.camel@obelisk.thedillows.org>
	 <20090524211557.GA14634@electric-eye.fr.zoreil.com>
Content-Type: text/plain
Date: Sun, 24 May 2009 18:55:46 -0400
Message-Id: <1243205746.3609.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-24 at 23:15 +0200, Francois Romieu wrote:
> David Dillow <dave@thedillows.org> :
> [...]
> > This fixes the lockups I've seen. Both MSI and level-triggered interrupt
> > configurations survive over an hour of testing when it would lockup in
> > under 90 seconds before. I am certain of the analysis of the root cause,
> > but there may be better ways to fix it. There may also be a theoretical
> > race window between the ending of a NAPI poll cycle and a link change
> > interrupt coming in, but I'm not sure it would matter. 
> 
> It makes sense.
> 
> If I understand correctly, one should expect to find some pending Tx
> event in the ISR of a failed card when reading the registers with
> ethtool.
> 
> Has someone noticed it ?

Yes, that's part of how I came to this conclusion, I put a debug patch
together that looked at the IRQ status 2 seconds after the last IRQ came
in. Then I waited for the chip to lock and the timer to fire. It showed
0x0085 in the IntrStatus register.

I didn't know I could do that with ethtool, but that would've been a
nice way to go, too. :)

