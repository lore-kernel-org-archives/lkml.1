Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbZFVOQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbZFVOQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZFVOQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:16:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37307 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750731AbZFVOQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:16:37 -0400
Date: Mon, 22 Jun 2009 10:16:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [patch update 2 fix] PM: Introduce core framework
 for run-time PM of I/O devices
In-Reply-To: <200906211332.46249.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906221007140.3081-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Jun 2009, Rafael J. Wysocki wrote:

> > Seriously, there _are_ places where drivers get bound to device before
> > those devices are registered.  This happens for example in USB when a
> > bunch of related interfaces are present in the same physical device.  
> > When the first interface is registered, its driver binds itself to all
> > the others even though they haven't been registered yet.
> 
> Well, the suspend functions could be protected against that under the
> assumption that no suspend is possible for resume_counter = 0 (then, the "good
> to go" value would be -1).
> 
> Still, the resume functions start from acquring a spinlock, which is not going
> to work if that spinlock is uninitialized.

The initialization needs to be improved.  Most of the code in
pm_runtime_init() should be called from device_pm_init(), and the rest
should be moved into a separate pm_runtime_add() routine to be called
from device_pm_add().

One of the things pm_runtime_add() could do is change the status from 
RPM_UNREGISTERED to RPM_ACTIVE.

Alan Stern

