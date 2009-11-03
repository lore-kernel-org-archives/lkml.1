Return-Path: <linux-kernel-owner+w=401wt.eu-S1753158AbZKCShn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbZKCShn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZKCShm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:37:42 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46527 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbZKCShm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:37:42 -0500
Date: Tue, 3 Nov 2009 19:37:39 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.32-rc5: unexpected thermal shutdown?
Message-ID: <20091103183739.GA3312@elf.ucw.cz>
References: <20091103105717.GA2516@elf.ucw.cz>
 <200911031825.04169.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911031825.04169.elendil@planet.nl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-11-03 18:25:03, Frans Pop wrote:
> Pavel Machek wrote:
> > I found this in the syslog afterwards.
> > 
> > Nov  3 09:59:14 amd kernel: Critical temperature reached (128 C),
> > shutting down.
> > Nov  3 09:59:14 amd shutdown[17819]: shutting down for system halt 
> > Nov  3 09:59:15 amd init: Switching to runlevel: 0
> 
> Looks like what happened to me earlier this year. See
> http://bugzilla.kernel.org/show_bug.cgi?id=13918.

Will take a look.

> > Now, machine was lying on the bed at that point, so...
> 
> So probably both the fan intake and hot air outlet were blocked, 
> effectively preventing cooling.

Well, no.  outlet was not blocked; parts of intake maybe.

> What hardware is this?

Thinkpad x60.

> What's the output of 'grep . /proc/acpi/thermal_zone/TZ*/*'?
> Any thermal zones in there that don't have a "passive" trip point?

128C means "slightly fake" temperature sensor. It seems that it just
produces 128 in THM0 when temperature exceeds some other limit.

pavel@amd:~$ grep . /proc/acpi/thermal_zone/*/*
/proc/acpi/thermal_zone/THM0/cooling_mode:<setting not supported>
/proc/acpi/thermal_zone/THM0/polling_frequency:<polling disabled>
/proc/acpi/thermal_zone/THM0/state:state:                   ok
/proc/acpi/thermal_zone/THM0/temperature:temperature:             58 C
/proc/acpi/thermal_zone/THM0/trip_points:critical (S5):           127
C
/proc/acpi/thermal_zone/THM1/cooling_mode:<setting not supported>
/proc/acpi/thermal_zone/THM1/polling_frequency:<polling disabled>
/proc/acpi/thermal_zone/THM1/state:state:                   ok
/proc/acpi/thermal_zone/THM1/temperature:temperature:             59 C
/proc/acpi/thermal_zone/THM1/trip_points:critical (S5):           97 C
/proc/acpi/thermal_zone/THM1/trip_points:passive:                 93
C: tc1=5 tc2=4 tsp=600 devices=CPU0 CPU1 
pavel@amd:~$ 

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
