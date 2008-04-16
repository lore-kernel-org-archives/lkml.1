Return-Path: <linux-kernel-owner+w=401wt.eu-S1764394AbYDPRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764394AbYDPRg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYDPRgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:36:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbYDPRgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:36:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "George Spelvin" <linux@horizon.com>
Subject: Re: 2.6.25 regression: 60417f5976df breaks Thinkpad suspend
Date: Wed, 16 Apr 2008 19:37:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: len.brown@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
References: <20080415115326.9915.qmail@science.horizon.com>
In-Reply-To: <20080415115326.9915.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804161937.25557.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 15 of April 2008, George Spelvin wrote:
> When trying a recent 2.6.25 on a laptop, I discovered that it
> completely breaks suspend to RAM.  It blanks the screen and lights up
> the sleeping light, but judging by the noises the laptop makes (help,
> low battery!) after being unplugged for a while, it doesn't actually
> suspend a whole lot.
> 
> More interestingly, it gets the laptop into a state where the only ways
> I can make it respond are disconnecting and connecting AC power (beep),
> and holding the power button down for 4 seconds.
> 
> The really interesting part is that after that, it won't turn on again!
> I have to disconnect power and remove the battery to reset it hard enough
> that it will respond to furtherpresses of the power button.
> 
> This smells like a BIOS bug to me, but it's interesting that it gets tickled.
> 
> The patch is unfortunately one that fixes other machines:
> 
> >   ACPI suspend: Call _PTS before suspending devices
> >   
> >   The ACPI 1.0 specification wants us to put devices into low power
> >   states after executing the _PTS global control method, while ACPI
> >   2.0 and later want us to do that in the reverse order.  The current
> >   suspend code follows ACPI 2.0 in that respect which causes some
> >   ACPI 1.0x systems to hang during suspend (ref.
> >   http://bugzilla.kernel.org/show_bug.cgi?id=9528).
> >   
> >   Make the suspend code execute _PTS before putting devices into low
> >   power states (ie. in accordance with ACPI 1.0x) and provide a command
> >   line option to override the default if need be.
> 
> Fortunately, the "acpi_new_pts_ordering" kernel parameter fixes it,
> but I waded through a full bisect (actually two, owing to some mistakes
> the first time) before finding out about it.

This change has been reverted from the current Linus' tree, so please check
if 2.6.25-rc9 (or a later git snapshot) works for you.

Thanks,
Rafael
