Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZGHO1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZGHO1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZGHO07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:26:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58290 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754454AbZGHO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:26:58 -0400
Date: Wed, 8 Jul 2009 10:26:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Magnus Damm <magnus.damm@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH] PM: Introduce core framework for run-time PM of
 I/O  devices (rev. 8)
In-Reply-To: <aec7e5c30907072140y7dd3b4c7ge7cb0b750bef3226@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0907081022250.2867-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Magnus Damm wrote:

> >> > All good with the code above, but there seem to be some issue with how
> >> > usage_count is counted up and down and when runtime_disabled is set:
> >> >
> >> > 1. pm_runtime_init(): usage_count = 1, runtime_disabled = true
> >> > 2. driver_probe_device(): pm_runtime_get_sync()
> >> > 3. pm_runtime_get_sync(): usage_count = 2
> >> > 4. device driver probe(): pm_runtime_enable()
> >> > 5. pm_runtime_enable(): usage_count = 1
> >> > 6. driver_probe_device(): pm_runtime_put()
> >> > 7. pm_runtime_put(): usage_count = 0
> >> >
> >> > I expect runtime_disabled = false in 7.
> >
> > Wasn't it?  It should have been set to false in step 4 and remained
> > that way.
> 
> I may misunderstand, but in v8 won't the pm_runtime_enable() function
> do a atomic_dec_test() where the counter value will go from 2 to 1 in
> the case above? This would mean that atomic_dec_test() returns false
> so runtime_disabled is never modified.

There still hasn't been any time for me to look through the code.  It 
sounds like Rafael was trying to use one counter for two separate 
purposes.

Alan Stern

