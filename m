Return-Path: <linux-kernel-owner+w=401wt.eu-S1751065AbZH1PnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbZH1PnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZH1PnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:43:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40901 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750761AbZH1PnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:43:04 -0400
Date: Fri, 28 Aug 2009 11:43:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
In-Reply-To: <200908262221.09224.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908281137110.4116-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Theoretically, the total time of system sleep transitions (suspend
> to RAM, hibernation) can be reduced by running suspend and resume
> callbacks of device drivers in parallel with each other.  However,
> there are dependencies between devices such that, for example, we may
> not be allowed to put one device into a low power state before
> anohter one has been suspended (e.g. we cannot suspend a bridge
> before suspending all devices behind it).  In particular, we're not
> allowed to suspend the parent of a device before suspending the
> device itself.  Analogously, we're not allowed to resume a device
> before resuming its parent.

> In this version of the patch the async threads started to execute
> the resume callbacks of specific device don't exit immediately having
> done that, but search dpm_list for devices whose PM dependencies have
> already been satisfied and execute their callbacks without waiting.

Given this design, why bother to invoke device_resume() for the async 
devices?  Why not just start up a bunch of async threads, each of which 
calls async_resume() repeatedly until everything is finished?  (And 
rearrange async_resume() to scan the list first and do the actual 
resume second.)

The same goes for the noirq versions.

Alan Stern

