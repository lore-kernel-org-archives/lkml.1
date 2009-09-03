Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZICWUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZICWUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZICWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:20:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285AbZICWUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:20:52 -0400
Date: Thu, 3 Sep 2009 15:20:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Sudhakar Rajashekhara" <sudhakar.raj@ti.com>
Cc: pavel@ucw.cz, linux-parport@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] parport: Add character LCD driver for da850/omap-l138
Message-Id: <20090903152042.bec9e4b8.akpm@linux-foundation.org>
In-Reply-To: <000901ca2bd4$bf245190$3d6cf4b0$@raj@ti.com>
References: <1251840159-22313-1-git-send-email-sudhakar.raj@ti.com>
	<20090901132330.GB1569@ucw.cz>
	<000901ca2bd4$bf245190$3d6cf4b0$@raj@ti.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Sep 2009 19:23:27 +0530
"Sudhakar Rajashekhara" <sudhakar.raj@ti.com> wrote:

> On Tue, Sep 01, 2009 at 18:53:30, Pavel Machek wrote:
> > Hi!
> > 
> > > On TI DA850/OMAP-L138 EVM, HD44780 (24x2) LCD panel is
> > > being used, interfaced through the SoC specific LCD
> > > interface[1].
> > > 
> > > Driver from drivers/staging/panel/panel.c works for this
> > > LCD panel but that driver expects the LCD panel to be
> > > interfaced through a parallel port.
> > > 
> > > This patch implements a dummy parallel port driver which
> > > interfaces to the panel driver in staging area through the
> > > LCD interface available on SoC.
> > 
> > This is a nasty hack, right? Just fixup panel.c to work with your
> > interface, too?
> > 								Pavel
> > 
> 
> Agree, that this is a hack. I have submitted a patch which modifies
> panel.c to support this kind of interface.
> 
> Currently the problem with panel.c is that, it is tightly coupled
> with parallel port interface. Panel driver needs to be completely
> re-written to de-couple parallel port related stuff. If I have to
> do this, then I need to start from ground zero as I do not have a
> setup on which HD44780 panel has been interfaced using parallel
> port. But I can certainly help here by testing such a modification
> to the panel driver by testing on the hardware what I have.
> 
> In the meantime, can I re-submit this patch by moving the dummy
> parallel port driver to reside in staging area? Later it can be
> moved/deleted depending on the modifications to the panel driver.
> 

If we're going to pull tricks like that then panel.c will never get
itself moved from outside staging/ :(

Really, I don't think we should be hacking things into drivers/parport/
code to accommodate design shortcomings in a staging/ driver.  Once done,
these things have a tendency to never be undone.
