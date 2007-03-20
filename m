Return-Path: <linux-kernel-owner+w=401wt.eu-S1751427AbXCTQ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbXCTQ5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXCTQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:57:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54016 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbXCTQ5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:57:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes-kernel@saeurebad.de>
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Date: Tue, 20 Mar 2007 18:00:27 +0100
User-Agent: KMail/1.9.5
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <20070320123245.GA19019@elf.ucw.cz> <20070320165058.GA15888@leiferikson>
In-Reply-To: <20070320165058.GA15888@leiferikson>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703201800.28024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 20 March 2007 17:50, Johannes Weiner wrote:
> Hi,
> 
> On Tue, Mar 20, 2007 at 01:32:45PM +0100, Pavel Machek wrote:
> > Date: Tue, 20 Mar 2007 13:32:45 +0100
> > From: Pavel Machek <pavel@ucw.cz>
> > To: "Rafael J. Wysocki" <rjw@sisk.pl>,
> > 	kernel list <linux-kernel@vger.kernel.org>
> > Cc: Andrew Morton <akpm@osdl.org>
> > Subject: "reboot" swsusp mode leaves moon icon blinking
> > 
> > Hi!
> > 
> > ...and cause is really simple.
> > 
> > During resume, we do not know that "reboot" method was used, so we
> > assume plaform and make the led blink...
> 
> What does the "reboot" swsusp mean?
> 
> I am having this (or a similar problem):
> 
> 	echo shutdown > /sys/power/disk; echo disk > /sys/power/state
> 
> suspends normally.  But after a resume, the moon keeps blinking _and_
> I don't get ACPI events anymore.  At least all ibm-acpi features refuse
> to work (hotkeys, lcd-brightness, lid, ...).
> 
> I saved some /proc files (interrupts, acpi/processor/power, ...) and
> compared them before the suspend and after the resume but I could not
> find any differences.
> 
> > diff --git a/kernel/power/disk.c b/kernel/power/disk.c
> > index 873cdf8..dee0ff4 100644
> > --- a/kernel/power/disk.c
> > +++ b/kernel/power/disk.c
> > @@ -241,18 +241,11 @@ static int software_resume(void)
> >  		goto Done;
> >  	}
> >  
> > -	error = platform_prepare();
> > -	if (error) {
> > -		swsusp_free();
> > -		goto Thaw;
> > -	}
> > -
> 
> What is platform_prepare() actually good for when _resuming_? I tried to
> follow the function calls and it seems to disable a lot of thing instead
> of re-enabling them...?

Well, if you suspend using the platform mode, platform_finish() will be called
after the image has been restored (ie. by the "old" kernel).

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
