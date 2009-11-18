Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbZKRRMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbZKRRMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZKRRMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:12:36 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47685 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913AbZKRRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:12:36 -0500
Date: Wed, 18 Nov 2009 18:12:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: -rc6: annoying thermal messages
Message-ID: <20091118171225.GF20887@elf.ucw.cz>
References: <20091116112304.GC12315@elf.ucw.cz>
 <1258376069.11110.1345439521@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258376069.11110.1345439521@webmail.messagingengine.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-11-16 10:54:29, Henrique de Moraes Holschuh wrote:
> n Mon, 16 Nov 2009 12:23 +0100, "Pavel Machek" <pavel@ucw.cz> wrote:
> >
> > My dmesg log is rather full of. Thinkpad x60.
> > Pavel
> 
> I think I will have to rate-limit it somehow.  Do we have any ready-to-
> use generic rate-limiters that can do 'once a minute', or should I
> cook my own?
> 
> But your thinkpad needs some sort of hardware loving care, it seems.
> What does "sensors" report (or cat /proc/acpi/ibm/thermal) ?

guest@amd:~/.gnupg$ cat /proc/acpi/ibm/thermal
temperatures:	59 49 -128 60 38 -128 34 -128 48 50 -128 -128 -128 -128 -128 -128

...sensors are not installed. I see THERMAL EMERGENCY in dmesg, but
I'm not sure how long ago it was generated.

> > thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
> > extremely hot!
> 
> That is a direct alarm from the firmware, the EC thinks your hardware
> is damaged and about to catch fire.

Well, working sensors report temperatures in 34C (battery) to 68C
range (PCI).

guest@amd:~$ cat /proc/acpi/thermal_zone/THM*/*
<setting not supported>
<polling disabled>
state:                   ok
temperature:             58 C
critical (S5):           127 C
<setting not supported>
<polling disabled>
state:                   ok
temperature:             67 C
critical (S5):           97 C
passive:                 93 C: tc1=5 tc2=4 tsp=600 devices=CPU0 CPU1 
guest@amd:~$ 

> Either that, or something  in the driver is seriously broken. But
> you're the first one to ever report that alarm :)

Well, being only in kernel log, those messages are not exactly easy to
notice.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
