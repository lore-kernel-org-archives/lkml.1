Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbYAIVww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbYAIVww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYAIVwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:52:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48873 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYAIVwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:52:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc7] remove obsolete /sys/devices/.../power/state docs
Date: Wed, 9 Jan 2008 22:55:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200801091212.24386.david-b@pacbell.net>
In-Reply-To: <200801091212.24386.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092255.09841.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 9 of January 2008, David Brownell wrote:
> The /sys/devices/.../power/state files have been gone for a while
> now, but I just noticed some documentation that still refers to
> them.  (Fortunately described as DEPRECATED and WILL REMOVE).
> 
> Time to remove that obsolete documentation too ...
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  Documentation/power/devices.txt |   49 ----------------------------------------
>  1 file changed, 49 deletions(-)
> 
> --- g26.orig/Documentation/power/devices.txt	2008-01-09 12:05:51.000000000 -0800
> +++ g26/Documentation/power/devices.txt	2008-01-09 12:06:33.000000000 -0800
> @@ -502,52 +502,3 @@ If the CPU can have a "cpufreq" driver, 
>  to shift to lower voltage settings and reduce the power cost of executing
>  a given number of instructions.  (Without voltage adjustment, it's rare
>  for cpufreq to save much power; the cost-per-instruction must go down.)
> -
> -
> -/sys/devices/.../power/state files
> -==================================
> -For now you can also test some of this functionality using sysfs.
> -
> -	DEPRECATED:  USE "power/state" ONLY FOR DRIVER TESTING, AND
> -	AVOID USING dev->power.power_state IN DRIVERS.
> -
> -	THESE WILL BE REMOVED.  IF THE "power/state" FILE GETS REPLACED,
> -	IT WILL BECOME SOMETHING COUPLED TO THE BUS OR DRIVER.
> -
> -In each device's directory, there is a 'power' directory, which contains
> -at least a 'state' file.  The value of this field is effectively boolean,
> -PM_EVENT_ON or PM_EVENT_SUSPEND.
> -
> -   *	Reading from this file displays a value corresponding to
> -	the power.power_state.event field.  All nonzero values are
> -	displayed as "2", corresponding to a low power state; zero
> -	is displayed as "0", corresponding to normal operation.
> -
> -   *	Writing to this file initiates a transition using the
> -   	specified event code number; only '0', '2', and '3' are
> -	accepted (without a newline); '2' and '3' are both
> -	mapped to PM_EVENT_SUSPEND.
> -
> -On writes, the PM core relies on that recorded event code and the device/bus
> -capabilities to determine whether it uses a partial suspend() or resume()
> -sequence to change things so that the recorded event corresponds to the
> -numeric parameter.
> -
> -   -	If the bus requires the irqs-disabled suspend_late()/resume_early()
> -	phases, writes fail because those operations are not supported here.
> -
> -   -	If the recorded value is the expected value, nothing is done.
> -
> -   -	If the recorded value is nonzero, the device is partially resumed,
> -	using the bus.resume() and/or class.resume() methods.
> -
> -   -	If the target value is nonzero, the device is partially suspended,
> -	using the class.suspend() and/or bus.suspend() methods and the
> -	PM_EVENT_SUSPEND message.
> -
> -Drivers have no way to tell whether their suspend() and resume() calls
> -have come through the sysfs power/state file or as part of entering a
> -system sleep state, except that when accessed through sysfs the normal
> -parent/child sequencing rules are ignored.  Drivers (such as bus, bridge,
> -or hub drivers) which expose child devices may need to enforce those rules
> -on their own.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
