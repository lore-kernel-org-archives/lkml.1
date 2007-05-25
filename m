Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbXEYWyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbXEYWyv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXEYWyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:54:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:38155 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbXEYWyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:54:44 -0400
Subject: Re: [patch 4/7] ps3: Storage Driver Probing
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0705252143270.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.474400000@sonycom.com> <200705251818.03964.arnd@arndb.de>
	 <Pine.LNX.4.62.0705252143270.2657@pademelon.sonytel.be>
Content-Type: text/plain
Date: Sat, 26 May 2007 08:54:13 +1000
Message-Id: <1180133653.19517.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-25 at 21:48 +0200, Geert Uytterhoeven wrote:
> > > +           msleep_interruptible(ms);
> > > +           if (ms < 60000)
> > > +                   ms <<= 1;
> > 
> > Is this timeout only for the disk spinup, or also for detecting
> media
> > added at run time, like inserting a DVD? One minute timeout for
> > detecting a DVD would sound very long to me.
> 
> It's not for inserting DVDs, only for new devices showing up in the
> repository.
> Apparently new devices may keep on showing up a while after boot up,
> but I
> think this matters only for the kboot kernel, that's why I went with
> the
> exponential back-off with upper limit.

Why not just have a kthread poll at 2 second interval for new devices or
removed ones ?

(And not for request processing)

Ben.


