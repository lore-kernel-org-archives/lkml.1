Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZEJPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZEJPz2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 11:55:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZEJPzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 11:55:15 -0400
Received: from bu3sch.de ([62.75.166.246]:60594 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbZEJPzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 11:55:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Riepe <michael.riepe@googlemail.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sun, 10 May 2009 17:53:34 +0200
User-Agent: KMail/1.9.9
Cc: Francois Romieu <romieu@fr.zoreil.com>, Rui Santos <rsantos@grupopie.com>,
       Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <200904041950.04324.mb@bu3sch.de> <4A06D8D2.4010505@googlemail.com>
In-Reply-To: <4A06D8D2.4010505@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905101753.35282.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 May 2009 15:38:26 Michael Riepe wrote:
> 
> Michael Buesch wrote:
> 
> > I'm currently testing 2.6.29.1 without any additional patches but
> > with the pci=nomsi boot option.
> > 
> > I didn't notice any hickups, yet. I'm running a stresstest on a GBit link for quite
> > some time now. Earlier tests with older kernels and MSI burped earlier.
> > 
> > I will do more testing. If it turns out this is stable I will test the same kernel
> > with Message Signaled Interrupts to see if that causes some breakage.
> 
> I've had this problem up to and including 2.6.29.2. Currently, I'm
> trying 2.6.29.2 with pci=nomsi, and it's stable so far. With MSI
> enabled, a single high-speed TCP transfer will stop after a few seconds,
> but without MSI, I can run four simultaneous transfers to two different
> hosts without a single hickup.
> 
> It seems to me that this particular chip really doesn't like MSI.

I can confirm this. I tried with msi enabled and it starts breaking
after a few seconds of heavy transfers. Disabling MSI results in a reliable connection.

Maybe we should disable MSI as temporary workaround for affected chips?

-- 
Greetings, Michael.
