Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbZKPNpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbZKPNpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbZKPNpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:45:13 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:52595 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZKPNpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:45:12 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: -rc6: something (probably active usb bluetooth) blocks suspend
Date: Mon, 16 Nov 2009 14:47:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-rc6-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20091116112254.GB12315@elf.ucw.cz> <200911161248.29924.oliver@neukum.org> <20091114111021.GA1378@ucw.cz>
In-Reply-To: <20091114111021.GA1378@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911161447.51651.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 14. November 2009 12:10:21 schrieb Pavel Machek:
> On Mon 2009-11-16 12:48:29, Oliver Neukum wrote:
> > Am Montag, 16. November 2009 12:22:54 schrieb Pavel Machek:
> >
> > Hi Pavle,
> >
> :-)
> :
> > first the obvious question. Does it work if you down the interface?
> > (not by killswitch)
> 
> Well, I'm not sure how repeatable it is. It happens once in two tries
> today.

Ok, so it looks like a race.

> > > usb 5-1: usb suspend
> > > usb 5-1: usb auto-resume
> > > uhci_hcd 0000:00:1d.3: port 1 portsc 0095,01
> > > usb 5-1: finish resume
> > > uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23
> > > us
> >
> > Why is the device autoresumed here? Are you using autosuspend?
> > This is odd, as the freezer should block the send path and remote
> > wakeups should be deferred.
> 
> I believe I have it enabled in kconfig but not during runtime.

Please check.
 
> (Another problem is that I need to turn the kill switch on/off to get
> my bt usb after resume. That used not be the case long time ago.)

That is possibly another problem.

	Regards
		Oliver
