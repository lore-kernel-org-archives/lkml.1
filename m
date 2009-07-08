Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZGHVJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZGHVJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754939AbZGHVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:09:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35929 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754547AbZGHVJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:09:09 -0400
Date: Wed, 8 Jul 2009 17:09:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Magnus Damm <magnus.damm@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of
 I/O devices (rev. 8)
In-Reply-To: <200907082155.40903.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0907081707090.22618-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Rafael J. Wysocki wrote:

> > I thought you wanted to avoid this sort of complication.
> 
> I did, but there might be some benefits.  For example, the timer and the work
> structure provided by dev.power can be used for scheduling such operations
> if they are defined at the core level.
> 
> Suppose your device has 3 low power states D1 - D3 (like PCI) and you want it
> to go into D1 first, then, after a delay, to D2 and finally, again after a
> delay, to D3.  Of course, if there's a resume in the meantime, it should cancel
> whichever transition is in progress.
> 
> pm_runtime_suspend() can be used for the first transition, but the bus type or
> driver will have to provide its own mechanics for going down to D2 and D3,
> which must be synchronized with its ->runtime_resume().  That might be tricky
> and the core already has what's necessary (well, almost).

Maybe we can provide a way for drivers to set up their own timer 
callback or work routine for use while the status is RPM_SUSPENDED.

Alan Stern

