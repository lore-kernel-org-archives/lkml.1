Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbXCDWdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbXCDWdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 17:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCDWdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 17:33:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33597 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXCDWdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 17:33:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: 2.6.20-mm2
Date: Sun, 4 Mar 2007 23:36:08 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org> <200702202307.45432.rjw@sisk.pl> <200702230836.37096.david-b@pacbell.net>
In-Reply-To: <200702230836.37096.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703042336.09103.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 23 February 2007 17:36, David Brownell wrote:
> > > > > rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> > > > > Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP: 
> > > > >  [<ffffffff804032c3>] rtc_sysfs_remove_device+0x23/0x50
> 
> The bug isn't in rtc_cmos, but that's the only driver that would currently
> show the bug.  (Triggered by finding the IRQ claimed by the legacy driver,
> result of a "but it should still be safe!" misconfiguration.)
> 
> The following fixes this on my 2.6.21-rc1 system; same fix should apply
> to MM2.
> 
> =====================	CUT HERE
> Fix an oops on the rtc_device_unregister() path by waiting until the
> last moment before nulling the rtc->ops vector.  Fix some potential
> oopses by having the rtc_class_open()/rtc_class_close() interface
> increase the RTC's reference count while an RTC handle is available
> outside the RTC framework.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

The patch fixes the Oops on my Asus L5D and allows it to suspend to disk
(without it the problem is present in 2.6.21-rc1 and 2.6.21-rc2).

I think it should go into 2.6.21.

Greetings,
Rafael
