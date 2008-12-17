Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752393AbYLQUgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbYLQUgT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYLQUgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:36:04 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34510 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750848AbYLQUgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:36:03 -0500
Message-ID: <494962AF.20003@sgi.com>
Date: Wed, 17 Dec 2008 12:35:59 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpumask: add sysfs displays for configured and	disabled
 cpu maps
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216042646.088194000@polaris-admin.engr.sgi.com> <200812172223.53079.rusty@rustcorp.com.au> <20081217184011.GB30724@suse.de>
In-Reply-To: <20081217184011.GB30724@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Dec 17, 2008 at 10:23:52PM +1030, Rusty Russell wrote:
>> On Tuesday 16 December 2008 14:56:48 Mike Travis wrote:
>>> Impact: add new functionality.
>>>
>>> Add sysfs files "kernel_max" and "offline" to display the max CPU index
>>> allowed (NR_CPUS-1), and the map of cpus that are offline. 
>> I've applied this to the cpumask series, but Greg is sysfs maestro, so
>> I'll await his ack (I've quoted whole thing for easy reading).
> 
> All new sysfs files should have corrisponding Documentation/ABI files
> added as well, containing all of the information in the body of this
> email so that others can find it in the future in an easy manner.
> 
> Mike, can you make this change please?

Yes, I will.
> 
>>> Cpus can be offlined via HOTPLUG, disabled by the BIOS ACPI tables, or
>>> if they exceed the number of cpus allowed by the NR_CPUS config option,
>>> or the "maxcpus=NUM" kernel start parameter.
>>>
>>> The "possible_cpus=NUM" parameter can also extend the number of possible
>>> cpus allowed, in which case the cpus not present at startup will be
>>> in the offline state.  (These cpus can be HOTPLUGGED ON after system
>>> startup [pending a follow-on patch to provide the capability via the
>>> /sys/devices/sys/cpu/cpuN/online mechanism to bring them online.])
>>>
>>> By design, the "offlined cpus > possible cpus" display will always
>>> use the following formats:
>>>
>>>   * all possible cpus online:   "x$"    or "x-y$" 
>>>   * some possible cpus offline: ".*,x$" or ".*,x-y$"
> 
> Care to provide an example of what these sysfs files will actually hold?
> It seems like you are craming more information than needed into a single
> sysfs file.

Well, it's somewhat of a cop out as well :*).  The cpus within 0 <= cpu < nr_cpu_ids
are printed with a cpulist_scnprintf.  This is printed for all architectures
and shows primarily cpus that either have been offlined via CPU HOTPLUG or
made possible by extending the number of "possible" cpus via a kernel start
parameter.

Those cpus that may actually be present in the system but their index exceeds
NR_CPUS/maxcpus are printed following the above and are appended to the list. 
If the list is non-empty, a comma is inserted first.  This keeps it all within
the syntax needed by cpulist_parse().  This is only done for x86 right now.

I'll put this info in the doc file.
> 
> Oh, and state why this is really needed, as I thought we already showed
> this kind of information today in the existing sysfs files, but I'm
> probably wrong :)

Almost, but not quite.  You can mine the syslog file to find if there's a
warning message but otherwise, "extra" cpus are silently ignored.

> 
> thanks,
> 
> greg k-h

Thanks!
Mike
