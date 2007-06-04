Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbXFDIIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbXFDIIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 04:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXFDIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 04:08:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37757 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbXFDIIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 04:08:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Date: Mon, 4 Jun 2007 10:13:48 +0200
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <878xb35sje.fsf@goat.bogus.local> <200706020037.16615.rjw@sisk.pl> <87wsykpweu.fsf@goat.bogus.local>
In-Reply-To: <87wsykpweu.fsf@goat.bogus.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706041013.49428.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 3 June 2007 23:20, Olaf Dietsche wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > Second, you can use PM_TRACE (Documentation/power/s2ram.txt) to find the
> > place where it really fails.
> 
> First I augmented my minimal config kernel with some TRACE_RESUME()s:
> 
> --- a/kernel/power/main.c	2007-05-27 23:48:05.000000000 +0200
> +++ b/kernel/power/main.c	2007-06-03 22:28:46.000000000 +0200
> @@ -223,6 +223,7 @@
>  	pr_debug("PM: Finishing wakeup.\n");
>  	suspend_finish(state);
>   Unlock:
> +	TRACE_RESUME(error);
>  	mutex_unlock(&pm_mutex);
>  	return error;
>  }
> @@ -303,6 +304,7 @@
>  		error = enter_state(state);
>  	else
>  		error = -EINVAL;
> +	TRACE_RESUME(error);
>  	return error ? error : n;
>  }
>  
> With this test script:
> 
> #! /bin/sh
> 
> sync
> echo 1 >/sys/power/pm_trace
> echo mem >/sys/power/state
> shutdown -rn now
> 
> I got alternating
>   hash matches drivers/base/power/resume.c:58
> and
>   hash matches kernel/power/main.c:307
> 
> > First, you can check if the patch
> >
> > http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc3/patches/20-ACPI-preserve-the-ebx-value-in-acpi_copy_wakeup_routine.patch
> 
> Then I applied this patch, but it doesn't change anything.
> 
> But either way the script never reaches "shutdown -rn now". So, it
> seems, that my laptop does a full resume every other reboot, but it
> never returns to userspace.

I'm still suspecting that the problem is related to your graphics adapter.

What graphics adapter do you have in the box?

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
