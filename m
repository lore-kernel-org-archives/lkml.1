Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYA1RHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYA1RHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761652AbYA1RGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:06:55 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:26768 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760776AbYA1RGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:06:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=CgNT/UTVMDjJZFegLGVaFkM/nMjeQWUy4WUtZOFueKoKrt3Yr3lmF8+U/pHCYRAUztMrKmgQPQUD3wnK13TaIvJjKCvrB8H/D1ZvksFlfD5wT/E/JNgqHfAqidc6BHXsGvUtsanZT5wfWCEiK03F9cGCa/AW7wTtltVXTpEMOhk=
Message-ID: <161717d50801280906s3acb72b4l9c98527526695ef5@mail.gmail.com>
Date: Mon, 28 Jan 2008 12:06:49 -0500
From: "Dave Neuer" <mr.fred.smoothie@pobox.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: Problem with ata layer in 2.6.24
Cc: "Mikael Pettersson" <mikpe@it.uu.se>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux ide Mailing list" <linux-ide@vger.kernel.org>
In-Reply-To: <200801281135.14555.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801272122.21823.gene.heskett@gmail.com>
	 <200801280754.53768.gene.heskett@gmail.com>
	 <18333.57152.472830.608248@harpo.it.uu.se>
	 <200801281135.14555.gene.heskett@gmail.com>
X-Google-Sender-Auth: 09fcedb7967ed32c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2008 11:35 AM, Gene Heskett <gene.heskett@gmail.com> wrote:
>
> On Monday 28 January 2008, Mikael Pettersson wrote:
> >
> >We have no way of debugging that module, so please try 2.6.24 without it.
>
> Sorry, I can't do this and have a working machine.  The nv driver has suffered
> bit rot or something since the FC2 days when it COULD run a 19" crt at
> 1600x1200, and will not drive this 20" wide screen lcd 1680x1050 monitor at
> more than 800x600, which is absolutely butt ugly fuzzy, looking like a jpg
> compressed to 10%.  The system is not usable on a day to basis without the
> nvidia driver.

I only have a 15.4" laptop screen, but it does 1650 x 1050 -- the
default w/ my Fedora 8 install -- with the nv driver no problem (I
change it because I have normal human eyesight rather than superhero
micro-vision).

>
> Fix the nv driver so it will run this screen at its native resolution and I'll
> be glad to run it even if it won't run google earth...

<snip>

>  Again, fix the nv driver so it will run my screen & I'll be glad
> to switch.

Wow, 2 separate demands to a Linux-IDE developer to fix an X driver
for you. Pretty sure that the source is available to you as well.

>
> >If the problems persist, please try to capture a complete log from the
> >failing kernel -- the interesting bits are everything from initial boot
> >up to and including the first few errors. You may need to increase the
> >kernel's log buffer size if the log gets truncated (CONFIG_LOG_BUF_SHIFT).
>
> If by log you mean /var/log/messages, I have several megabytes of those.
> If you mean a live dmesg capture taken right now, its attached. It contains
> several of these at the bottom.  I long ago made the kernel log buffer
> bigger, cuz it couldn't even show the start immediately after the boot, and
> even the dump to syslog was truncated.
>
> >There are no pata_amd changes from 2.6.24-rc7 to 2.6.24 final.
>
> That is what I was afraid of.  I've done some limited grepping in that branch
> of the kernel tree, and cannot seem to locate where this EH handler is being
> invoked from.
>
> There is 2 lines of interest in the dmesg:
>
> [    0.000000] Nvidia board detected. Ignoring ACPI timer override.
> [    0.000000] If you got timer trouble try acpi_use_timer_override
>
> But I have NDI what it means, kernel argument/xconfig option?

My own 15 seconds of googling informs me that it's a kernel
command-line option: put it on the command-line as-is.

>
> I've also done some googling, and it appears this problem is fairly widespread
> since the switchover to libata was encouraged.  A stock fedora F8 kernel
> suffers the same freezes and eventually locks up, but does it without the
> error messages being logged, it just freezes, feeling identical to this in
> the minutes before the total freeze.  I've tried 2 of those too, but the
> newest one won't even run X.

As I said, I run F8 w/ nv on my amd64 laptop, so I'm not sure what you
mean by the "won't even run X" part there.

Dave
