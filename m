Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbZJTHqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbZJTHqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 03:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZJTHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 03:46:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZJTHqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 03:46:48 -0400
Date: Tue, 20 Oct 2009 09:46:12 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] PPC-BRIQ_PANEL: Remove BKL and replace with atomic
 variable.
In-Reply-To: <20091019220129.GE4880@nowhere>
Message-ID: <alpine.LFD.2.00.0910200938230.3609@localhost.localdomain>
References: <alpine.LFD.2.00.0910182137470.3462@localhost.localdomain> <alpine.LFD.2.00.0910190658070.4975@localhost.localdomain> <20091019220129.GE4880@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Oct 2009, Frederic Weisbecker wrote:

> On Mon, Oct 19, 2009 at 07:04:02AM +0200, Thomas Gleixner wrote:
> > B1;2005;0cOn Sun, 18 Oct 2009, John Kacur wrote:
> > 
> > > >From b64c7d0f11eab96cb253b23c7264c999746116c0 Mon Sep 17 00:00:00 2001
> > > From: John Kacur <jkacur@redhat.com>
> > > Date: Sun, 18 Oct 2009 21:29:21 +0200
> > > Subject: [PATCH] PPC-BRIQ_PANEL: Remove BKL and replace with atomic variable.
> > > 
> > > There are no locks here except the bkl in briq_panel_open. It's only
> > > purpose is to ensure single access. Remove the bkl and ensure single access
> > > by making vfd_is_open an atomic_variable.
> > 
> > And again, can you please look more carefully at the init
> > vs. read/write functions ?
> > 
> > The BKL is not only protecting the single user variable it's also
> > serializing write against the access to the display in init.
> > 
> > Thanks,
> > 
> > 	tglx
> 
> 
> That could be solved by statically initializing vfd_is_open to -1
> and then set it to 0 once briq_panel_init has finished initializing
> the device.

Well, I did think of a similar scheme, but in another chat or email, 
(don't remember which) Thomas told me that any such synchronization is a 
hack, the only correct thing to do is fix the init.
His point being, either the device is available to functions like read or 
write or it isn't. However, that sync technique seems so simple here, I 
may not give up on it.
 > 
