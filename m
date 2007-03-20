Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXCTQvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXCTQvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXCTQvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:51:07 -0400
Received: from saeurebad.de ([85.214.36.134]:59794 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXCTQvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:51:06 -0400
Date: Tue, 20 Mar 2007 17:50:59 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: "reboot" swsusp mode leaves moon icon blinking
Message-ID: <20070320165058.GA15888@leiferikson>
Mail-Followup-To: kernel list <linux-kernel@vger.kernel.org>
References: <20070320123245.GA19019@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320123245.GA19019@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 20, 2007 at 01:32:45PM +0100, Pavel Machek wrote:
> Date: Tue, 20 Mar 2007 13:32:45 +0100
> From: Pavel Machek <pavel@ucw.cz>
> To: "Rafael J. Wysocki" <rjw@sisk.pl>,
> 	kernel list <linux-kernel@vger.kernel.org>
> Cc: Andrew Morton <akpm@osdl.org>
> Subject: "reboot" swsusp mode leaves moon icon blinking
> 
> Hi!
> 
> ...and cause is really simple.
> 
> During resume, we do not know that "reboot" method was used, so we
> assume plaform and make the led blink...

What does the "reboot" swsusp mean?

I am having this (or a similar problem):

	echo shutdown > /sys/power/disk; echo disk > /sys/power/state

suspends normally.  But after a resume, the moon keeps blinking _and_
I don't get ACPI events anymore.  At least all ibm-acpi features refuse
to work (hotkeys, lcd-brightness, lid, ...).

I saved some /proc files (interrupts, acpi/processor/power, ...) and
compared them before the suspend and after the resume but I could not
find any differences.

> diff --git a/kernel/power/disk.c b/kernel/power/disk.c
> index 873cdf8..dee0ff4 100644
> --- a/kernel/power/disk.c
> +++ b/kernel/power/disk.c
> @@ -241,18 +241,11 @@ static int software_resume(void)
>  		goto Done;
>  	}
>  
> -	error = platform_prepare();
> -	if (error) {
> -		swsusp_free();
> -		goto Thaw;
> -	}
> -

What is platform_prepare() actually good for when _resuming_? I tried to
follow the function calls and it seems to disable a lot of thing instead
of re-enabling them...?

=Hannes
