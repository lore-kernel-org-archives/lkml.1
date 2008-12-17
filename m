Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752459AbYLQSro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbYLQSro (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYLQSra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:47:30 -0500
Received: from mx1.suse.de ([195.135.220.2]:47190 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYLQSr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:47:29 -0500
Date: Wed, 17 Dec 2008 10:40:11 -0800
From: Greg KH <gregkh@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpumask: add sysfs displays for configured and
	disabled cpu maps
Message-ID: <20081217184011.GB30724@suse.de>
References: <20081216042645.629941000@polaris-admin.engr.sgi.com> <20081216042646.088194000@polaris-admin.engr.sgi.com> <200812172223.53079.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812172223.53079.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:23:52PM +1030, Rusty Russell wrote:
> On Tuesday 16 December 2008 14:56:48 Mike Travis wrote:
> > Impact: add new functionality.
> > 
> > Add sysfs files "kernel_max" and "offline" to display the max CPU index
> > allowed (NR_CPUS-1), and the map of cpus that are offline. 
> 
> I've applied this to the cpumask series, but Greg is sysfs maestro, so
> I'll await his ack (I've quoted whole thing for easy reading).

All new sysfs files should have corrisponding Documentation/ABI files
added as well, containing all of the information in the body of this
email so that others can find it in the future in an easy manner.

Mike, can you make this change please?

> > Cpus can be offlined via HOTPLUG, disabled by the BIOS ACPI tables, or
> > if they exceed the number of cpus allowed by the NR_CPUS config option,
> > or the "maxcpus=NUM" kernel start parameter.
> > 
> > The "possible_cpus=NUM" parameter can also extend the number of possible
> > cpus allowed, in which case the cpus not present at startup will be
> > in the offline state.  (These cpus can be HOTPLUGGED ON after system
> > startup [pending a follow-on patch to provide the capability via the
> > /sys/devices/sys/cpu/cpuN/online mechanism to bring them online.])
> > 
> > By design, the "offlined cpus > possible cpus" display will always
> > use the following formats:
> > 
> >   * all possible cpus online:   "x$"    or "x-y$" 
> >   * some possible cpus offline: ".*,x$" or ".*,x-y$"

Care to provide an example of what these sysfs files will actually hold?
It seems like you are craming more information than needed into a single
sysfs file.

Oh, and state why this is really needed, as I thought we already showed
this kind of information today in the existing sysfs files, but I'm
probably wrong :)

thanks,

greg k-h
