Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbXHAQ6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbXHAQ6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755057AbXHAQ6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:58:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:51934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430AbXHAQ6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:58:45 -0400
Date: Wed, 1 Aug 2007 18:58:15 +0200
From: Stefan Seyfried <seife@suse.de>
To: david@lang.hm
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Al Boldi <a1426z@gawab.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Machek <pavel@ucw.cz>, "Huang, Ying" <ying.huang@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation considerations
Message-ID: <20070801165815.GA19065@suse.de>
References: <Pine.LNX.4.44L0.0707171010490.3551-100000@iolanthe.rowland.org> <200707171802.30903.rjw@sisk.pl> <Pine.LNX.4.64.0707170959160.2467@asgard.lang.hm> <200707172150.44417.rjw@sisk.pl> <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707171302430.2467@asgard.lang.hm>
X-Operating-System: openSUSE 10.3 (i586) Alpha7, Kernel 2.6.22.1-10-default
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for joining late, just a small annotation:

On Tue, Jul 17, 2007 at 01:18:13PM -0700, david@lang.hm wrote:
 
> non-ACPI hibernate
> 
>   since the box powers off
>     it uses zero power while suspended
>     another OS could be run before a resume
>     hardware can be swapped, suspend image could be sent around the world to be restored on another system.
>     restore makes no assumptions about the state of the hardware when it is restored
>     restore is slower (full BIOS boot is required)
>   should be able to work on just about any hardware (the limit is the ability to initialize the devices)
> 
> 
> ACPI suspends
> 
>   since the box never completely powers off:A

wrong

>     a complete power failure breaks the suspend

wrong

>     the OS must remain in control so other uses must be prevented.
>     hardware must remain in the ACPI state from suspend until restore.
>     restore can be faster (some initialization may be able to be skipped)
>   requires ACPI hardware support
> 
> under the catagory of ACPI suspends you have

ACPI S4 turns off the machine completely and you can remove the battery (this
is even required somewhere in the spec). Any state saving is done in CMOS RAM
or flash.

But for example many Notebooks resume much faster if they go through the
ACPI S4 hooks during suspend (less than one second from "lid open" to "grub"
while they need ~10 seconds through the BIOS on a "normal" boot.
My Toughbook resumes on "Lid Opened" after S4, it doesn't after a shutdown.

So there will be differences.
I'm not saying that they are too important, but 20% faster resume still is
a good saving for me.

No need to restart this thread btw ;-)

Have fun,

    Stefan
-- 
Stefan Seyfried
QA / R&D Team Mobile Devices        |              "Any ideas, John?"
SUSE LINUX Products GmbH, Nürnberg  | "Well, surrounding them's out." 

This footer brought to you by insane German lawmakers:
SUSE Linux Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
