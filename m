Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYAKPHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYAKPHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbYAKPHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:07:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55017 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756716AbYAKPHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:07:40 -0500
Date: Fri, 11 Jan 2008 10:07:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <gregkh@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend (rev. 3)
In-Reply-To: <200801110216.35446.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801111006410.4263-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008, Rafael J. Wysocki wrote:

> Hi,
> 
> The patch below is intended as a replacement for
> gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch that deadlocked
> suspend and hibernation on some systems.  The present patch contains some
> safeguards against deadlocks in the relevant cases and a mechanism to print
> warnings if a deadlock is probable.
> 
> Greetings,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
> 
> This patch reorganizes the way suspend and resume notifications are
> sent to drivers.  The major changes are that now the PM core acquires
> every device semaphore before calling the methods, and calls to
> device_add() during suspends will fail, while calls to device_del()
> during suspends will block.
> 
> It also provides a way to safely remove a suspended device with the
> help of the PM core, by using the device_pm_schedule_removal() callback
> introduced specifically for this purpose, and updates two drivers (msr
> and cpuid) that need to use it.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

