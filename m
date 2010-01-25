Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540Ab0AYPJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0AYPJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 10:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988Ab0AYPJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 10:09:04 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:50529 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab0AYPJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 10:09:00 -0500
Date: Mon, 25 Jan 2010 16:08:50 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@localhost
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending
 devices
In-Reply-To: <201001222148.23945.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.1001251601440.2100@localhost>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <201001222148.23945.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Organization: "IBM Deutschland Research & Development GmbH Vorsitzender des Aufsichtsrats: Martin Jetter Geschaeftsfuehrung: Dirk Wittkopp Sitz der Gesellschaft: Boeblingen Registergericht: Amtsgericht Stuttgart, HRB 243294"
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, 22 Jan 2010, Rafael J. Wysocki wrote:

> On Friday 22 January 2010, Sebastian Ott wrote:
> > 
> > a possible fix would be to call disable_nonboot_cpus before suspending the
> > devices..
> 
> This is going against the changes attempting to speed-up suspend and resume,
> such as the asynchronous suspend/resume patchset, so I don't agree with it.

Isn't the main benefit for this scenario that while a driver starts io and
waits for interrupts, the callback for the next device can be called? And
this can be done with one cpu as well.

> 
> The real solution would be to remove the memory allocations from the
> _cpu_down() call path.

So you have to also ban allocations from all registered notifiers at the
cpu_chain. And since enable_nonboot_cpus is called before the devices are
woken up, the same would be true for _cpu_up() which may not be done
easily.

> 
> BTW, this is one of the cases I and Ben are talking about where it's not
> practical to rework the code just to avoid memory allocation problems during
> suspend/resume.

Ok. All i'm saying is that in hibernation_snapshot/create_image memory
allocations are directely triggered after all devices were put to sleep /
before woken up - and this looks like a bug.

For the driver case - what about using your patch to not modify the gfp
mask but print a warning instead so that these drivers can be identified
and fixed.

Regards,
Sebastian
