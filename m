Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbXHUMGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbXHUMGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXHUMGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:06:35 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:35368 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbXHUMGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:06:35 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with =?utf-8?q?linux=09v2=2E6=2E23-rc3-50-g28e8351?=
Date: Tue, 21 Aug 2007 14:06:31 +0200
User-Agent: KMail/1.9.7
Cc: Florin Iucha <florin@iucha.net>, Jiri Kosina <jikos@jikos.cz>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net>
In-Reply-To: <20070821115115.GD10422@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708211406.31726.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 21 August 2007 schrieb Florin Iucha:
> On Wed, Aug 15, 2007 at 04:58:33PM +0200, Jiri Kosina wrote:
> > On Wed, 15 Aug 2007, Florin Iucha wrote:
> > 
> > > [See my message to Alan]: It happened twice, within 15 minutes of 
> > > boot+login, with 2.6.23-rc3-$whatever .  I does not happen with 
> > > 2.6.2[123](-rc*)?  After the two incidents, I rebooted in 2.6.23-rc2 and 
> > > it is working for an hour now.
> > 
> > It is not immediately clear what might be causing this, 2.6.23-rc3 didn't 
> > get any USB nor HID updates at all compared to 2.6.23-rc2.
> > 
> > Could you please enable USB and HID debugging to see whether we can see 
> > anything spurious in the logs at the time the keyboard gets stuck?
> 
> Jiri,
> 
> I have enabled USB debugging and I see a bunch (=46) of these messages:
> 
>    [  $timestamp] usb 1-9: usb auto-suspend
>    [  $timestamp] usb 1-9: usb auto-resume
>    [  $timestamp] ehci_hcd 0000:00:02.1: GetStatus port 9 status 001005 POWER sig=se0 PE CONNECT
>    [  $timestamp] usb 1-9: finish resume
> 
> The messages continued to be logged, even after the keyboard has
> become unresponsive.

[   60.756730] usb 1-9: usb auto-resume
Did you hit a key at that time?


It looks like your keyboard gets autosuspended. But how can that happen?
Keyboards should never autosuspend, as they are always open.
The patch for minimum autosuspend support in HID did get in earlier,
didn't it?

	Regards
		Oliver


