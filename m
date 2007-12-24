Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXLXPvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXLXPvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750934AbXLXPvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:51:17 -0500
Received: from netrider.rowland.org ([192.131.102.5]:3724 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750779AbXLXPvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:51:17 -0500
Date: Mon, 24 Dec 2007 10:51:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3] PM: Do not destroy/create devices while suspended
In-Reply-To: <200712240155.14765.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0712241045150.25920-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Dec 2007, Rafael J. Wysocki wrote:

> Hi,
> 
> Some device drivers register CPU hotplug notifiers and use them to destroy
> device objects when removing the corresponding CPUs and to create these objects
> when adding the CPUs back.
> 
> Unfortunately, this is not the right thing to do during suspend/hibernation,
> since in that cases the CPU hotplug notifiers are called after suspending
> devices and before resuming them, so the operations in question are carried
> out on the objects representing suspended devices which shouldn't be
> unregistered behing the PM core's back.  Although right now it usually doesn't
> lead to any practical complications, it will predictably deadlock if
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch is applied.
> 
> The solution is to prevent drivers from removing/adding devices from within
> CPU hotplug notifiers during suspend/hibernation using the FROZEN bit
> in the notifier's action argument.  The following three patches modify the
> MSR, x86-64 MCE and cpuid drivers along these lines.

Do we need to worry about the possibility that when the system wakes up 
from hibernation, the set of usable CPUs might be smaller than it was 
beforehand?  Is any special handling needed for this, or is it already 
accounted for?

Alan Stern

