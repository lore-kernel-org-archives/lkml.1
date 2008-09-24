Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYIXVFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYIXVFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIXVEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:04:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49471 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbYIXVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:04:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Regression in 2.6.27-rc7: Wake On LAN with sky2 broken
Date: Wed, 24 Sep 2008 23:10:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20080924080546.GA21108@x61> <200809242113.52256.rjw@sisk.pl> <20080924194906.GA25874@x61>
In-Reply-To: <20080924194906.GA25874@x61>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809242310.23477.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 24 of September 2008, Tino Keitel wrote:
> On Wed, Sep 24, 2008 at 21:13:51 +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 24 of September 2008, Tino Keitel wrote:
> > > Hi,
> > > 
> > > Wake On LAN from suspend to RAM doesn't work on my Mac mini Core Duo
> > > with 2.6.27-rc7. I tested the same configuration with 2.6.26.3, and it
> > > worked. With 2.6.27-rc7, the computer stays in suspended state. I can
> > > still wake it up using the keyboard or power switch.
> > > 
> > > In my suspend script, I use the command "ethtool -s eth0 wol g" to
> > > enable WOL even if it was disabled before.
> > > 
> > > Any hints what commit I should try to revert, before I start bisecting?
> > 
> > Please try the appended patch.
> 
> With this patch, the computer hangs during suspend.

This is not good.  It probably means that it actually tries to set up the NIC
for waking up the system, but something broke _that_ for you.

FWIW, I tried it on my test machine with sky2 and it worked.

Can you try:

# ethtool -s eth0 wol g
# echo devices > /sys/power/pm_test
# echo mem > /sys/power/state
(this should wait for 5 seconds and return to the command line)

and see if the machine hangs during this operation?

Please also attach the boot log from your system.

Thanks,
Rafael
