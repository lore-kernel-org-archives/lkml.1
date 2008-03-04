Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbYCDGFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbYCDGFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYCDGFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:05:25 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:33588 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbYCDGFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:05:24 -0500
Date: Tue, 4 Mar 2008 07:03:57 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
Message-ID: <20080304070357.61ee825b@mjolnir.drzeus.cx>
In-Reply-To: <200803031359.38263.david-b@pacbell.net>
References: <200802241500.41969.rjw@sisk.pl>
	<Pine.LNX.4.44L0.0802240941440.29504-100000@netrider.rowland.org>
	<20080225184102.0a2e2bb5@mjolnir.drzeus.cx>
	<200803031359.38263.david-b@pacbell.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008 13:59:37 -0800
David Brownell <david-b@pacbell.net> wrote:

> 
> Card insert/remove events can be system wake events though.  Which
> makes that restriction impractical.
> 
> I think hosts need to be able to call mmc_detect_change() as soon as
> they see a stable signal.  The MMC core can hold off handling that
> for a while, if it needs to wait until the code walking the device
> tree gets around to resuming that host.  It's a lot more natural to
> hold off such stuff one time there than in N host drivers; especially
> since the MMC core already has such hold-off code.
> 

That actually sorts itself out as the MMC core reprobes on wakeup, but I see your point. Right now things will work peachy if the controllers just make sure to disable their card detection logic before telling the core to suspend.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
