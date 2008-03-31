Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYCaQSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYCaQSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 12:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYCaQSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 12:18:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52782 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYCaQSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 12:18:44 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7:  Ugh.
Date: Mon, 31 Mar 2008 18:37:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
References: <47EBBD57.30902@rtr.ca> <200803311704.37256.oliver@neukum.org> <47F0FD8E.4090005@rtr.ca>
In-Reply-To: <47F0FD8E.4090005@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803311837.30129.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. März 2008 17:04:46 schrieb Mark Lord:
> Oliver Neukum wrote:
> > Am Montag, 31. März 2008 16:39:33 schrieb Mark Lord:
> >
> >> One thing I just tried, was to unload all USB stuff before suspend,
> >> and reload on resume -- just stuck the commands into my suspend/resume script.
> >>
> >> The machine has been 100% rock solid since then.
> >> So I think that definitely implicates USB.
> > 
> > Yes. What happens if you unload only usbhid at that time?
> ..
> 
> Mmm.. interesting choice, there.  I'll try that.
> 
> There is another quirk on this machine that might confuse
> software that's not robust:  the internal Bluetooth adapter
> is USB connected, and I normally have it disabled (BIOS hotkey).
> So it normally is "not present".
> 
> But on any power-on / resume, it briefly powers up and becomes "present",
> and, after a second or two, the BIOS powers it down again, "not present".
> 
> Just long enough for software to notice it and try talking to it.
> If that software is not carefully coded, it might get confused.
> 
> This has not been a problem before, but perhaps with the new USB autosuspend code?

hci_usb doesn't have any autosuspend code.

> >> Still want USB_SUSPEND=n ?  Please explain.
> > 
> > It looks like you are hanging in the kthread for autosuspending.
> > Compiling that out should confirm it.
> ..
> 
> Okay, and once we see that it works fine:  then what?

We'll combine that information with the result of only removing usbhid
and arrive at a pretty good idea where in the kernel the hang occurs.
There are only two functions that touch autosuspend in the usbhid code.
So if it works with usbhid unloaded, either of them should be to blame.

	Regards
		Oliver


