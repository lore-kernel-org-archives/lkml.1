Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXCTSBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXCTSBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXCTSBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:01:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40647 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751942AbXCTSBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:01:39 -0400
Date: Tue, 20 Mar 2007 19:01:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Message-ID: <20070320180121.GA2856@elf.ucw.cz>
References: <20070320123245.GA19019@elf.ucw.cz> <20070320165058.GA15888@leiferikson>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320165058.GA15888@leiferikson>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...and cause is really simple.
> > 
> > During resume, we do not know that "reboot" method was used, so we
> > assume plaform and make the led blink...
> 
> What does the "reboot" swsusp mean?

echo reboot > ...disk.

> I am having this (or a similar problem):
> 
> 	echo shutdown > /sys/power/disk; echo disk > /sys/power/state

Yep, that's duplicate. Try patch below.
								Pavel

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
> 
> =Hannes
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
