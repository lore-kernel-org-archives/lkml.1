Return-Path: <linux-kernel-owner+w=401wt.eu-S1753926AbZGXTA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbZGXTA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZGXTA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:00:58 -0400
Received: from bu3sch.de ([62.75.166.246]:48579 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZGXTA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:00:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ben Gardner <gardner.ben@gmail.com>
Subject: Re: FW: [PATCH] cs5535_gpio: Fix root triggerable integer underflow
Date: Fri, 24 Jul 2009 21:00:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <F06EB2894F3F0D45AD9BEA7246DE9C900E542FE2@WCSEXCMBS1.ad.wabtec.com> <808c8e9d0907241040i2783d27aw948aa239f521336c@mail.gmail.com>
In-Reply-To: <808c8e9d0907241040i2783d27aw948aa239f521336c@mail.gmail.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907242100.56097.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009 19:40:28 Ben Gardner wrote:
> Hi Michael,
> 
> > This patch fixes a possible root triggerable (I hope the device is only
> > readable by root?) integer underflow.
> > Well, it's not really an underflow, but as loff_t is a signed type, the
> > range check at the start of the function is incomplete. It needs to
> > check for <0, too.
> > Otherwise the loop below will poke into random memory and I/O space.
> > This could be used to crash the machine, at least.
> >
> > This patch is only compiletested, because I do not have the hardware.
> >
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> >
> > ---
> >
> > I'm not sure if this bug is exploitable. I _guess_ the device is only
> > readable by root
> > on a standard setup.
> 
> The cs5525_gpio driver uses the default seek, which doesn't allow
> negative position values.
> So, I don't think it necessary to check for negative values.

Yes you are right.

-- 
Greetings, Michael.
