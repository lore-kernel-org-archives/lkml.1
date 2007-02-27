Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXB0JkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXB0JkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161123AbXB0JkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:40:01 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51964 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161115AbXB0Jj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:39:59 -0500
Date: Tue, 27 Feb 2007 10:39:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Dave Jones <davej@redhat.com>, linux-acpi@vger.kernel.org,
       Adam Belay <abelay@novell.com>, Shaohua Li <shaohua.li@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 3/3]cpuidle take2: Basic documentation for cpuidle
Message-ID: <20070227093936.GA6766@elf.ucw.cz>
References: <20070222135457.C26335@unix-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070222135457.C26335@unix-os.sc.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Documentation for cpuidle infrastructure
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Adam Belay <abelay@novell.com>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Index: linux-2.6.21-rc-mm/Documentation/cpuidle/core.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc-mm/Documentation/cpuidle/core.txt
> @@ -0,0 +1,17 @@
> +
> +		Supporting multiple CPU idle levels in kernel
> +
> +				cpuidle
> +
> +General Information:
> +
> +Various CPUs today support multiple idle levels that are differentiated
> +by varying exit latencies and power consumption during idle.
> +cpuidle is a generic in-kernel infrastructure that separates
> +idle policy (governor) from idle mechanism (driver) and provides a
> +standardized infrastructure to support independent development of
> +governors and drivers.
> +
> +cpuidle resides under /drivers/cpuidle.

Drop leading slash? Merge this to some other docs, since it is so
short?


> Index: linux-2.6.21-rc-mm/Documentation/cpuidle/driver.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc-mm/Documentation/cpuidle/driver.txt
> @@ -0,0 +1,24 @@
> +
> +
> +		Supporting multiple CPU idle levels in kernel
> +
> +				cpuidle drivers
> +
> +
> +
> +
> +cpuidle driver supports capability detection for a particular system. The
> +init and exit routines will be called for each online CPU, with a percpu
> +cpuidle_driver object and driver should fill in cpuidle_states inside
> +cpuidle_driver depending on the CPU capability.

Huh, perhaps it would be nice to explain what the driver does?

Now we know that it does...

> +Driver can handle dynamic state changes (like battery<->AC), by calling
> +force_redetect interface.
> +
> +It is possible to have more than one driver registered at the same time and
> +user can switch between drivers using /sysfs interface.
> +
> +Interfaces:
> +int cpuidle_register_driver(struct cpuidle_driver *drv);
> +void cpuidle_unregister_driver(struct cpuidle_driver *drv);
> +int cpuidle_force_redetect(struct cpuidle_device *dev);

register, unregister and redetect... but that somehow does not seem complete?

> Index: linux-2.6.21-rc-mm/Documentation/cpuidle/sysfs.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6.21-rc-mm/Documentation/cpuidle/sysfs.txt
> @@ -0,0 +1,27 @@
> +
> +
> +		Supporting multiple CPU idle levels in kernel
> +
> +				cpuidle sysfs
> +
> +System global cpuidle information are under
> +/sys/devices/system/cpu/cpuidle

"information is"? (Not 100% sure).

> +Under this percpu directory, there is a directory for each idle state supported
> +by the driver, which in turn has
> +* latency
> +* power
> +* time
> +* usage

This should say... latency (in microseconds), power (in miliwats), and
explain what time (which units?) and usage means. (Total time spent in
that state, usage == number of enters into that state?)

> +		Supporting multiple CPU idle levels in kernel
> +
> +				cpuidle governors
> +
> +
> +cpuidle governor is policy routine that decides what idle state to enter at
> +any given time. cpuidle core uses different callbacks to governor while
> +handling idle entry.
> +* select_state callback where governor can determine next idle state to enter
> +* prepare_idle callback is called before entering an idle state
> +* scan callback is called after a driver forces redetection of the states

Can we get some visual separation between functions and their
descriptions?

scan() callback?

scan -- callback?

> +More than one governor can be registered at the same time and
> +user can switch between drivers using /sysfs interface.

<describe interface here>?

Explain why we want more than one governor?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
