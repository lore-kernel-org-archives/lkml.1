Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbXCYMZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbXCYMZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbXCYMZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:25:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45650 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493AbXCYMZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:25:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Sun, 25 Mar 2007 14:28:02 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <46065FED.8030206@m3y3r.de> <m11wjd4jiq.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m11wjd4jiq.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703251428.03382.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 March 2007 14:03, Eric W. Biederman wrote:
> Thomas Meyer <thomas@m3y3r.de> writes:
> 
> > Eric W. Biederman schrieb:
> >>
> >> Thomas could you verify the patch below makes the problem go away
> >> for you.
> >>   
> >
> > The patch solves the problem. I'm writing this after the third suspend
> > and resume cycle.
> > msi irq stays enabled for libata device:
> > cat /sys/devices/pci0000\:00/0000\:00\:1f.2/irq
> > 218
> 
> > The first suspend to disk is ok. The second suspend to disk has a
> > strange behaviour:
> > 1.) write pm image
> > 2.) the system disable the non-boot cpus again (i guess this happens in
> > power_down())

Yes, in kernel/power/disk.c:power_down() .

Please comment out the disable_nonboot_cpus() in there and retest (but please
test the latest Linus' tree).

> > 3.) the system doesn't power down.
> > 4.) pressing any key and the system powers down.
> >
> > The same is true for the third suspend cycle. Maybe an acpi problem?
> 
> Sounds possible.  You could probably verify it isn't my patch but running
> an unpatched kernel without msi support.  As I think the crash you saw should
> only be reproducible when using devices that support msi.
> 
> Unless I hear different I'm going to assume that this second case is a
> completely different problem.

I think it is different too.

Greetings,
Rafael
