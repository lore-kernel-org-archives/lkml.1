Return-Path: <linux-kernel-owner+w=401wt.eu-S1752729AbZH0UqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbZH0UqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 16:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbZH0UqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 16:46:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39260 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752675AbZH0UqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 16:46:08 -0400
Date: Thu, 27 Aug 2009 16:46:08 -0400 (EDT)
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
Subject: Re: [PATCH 0/6] PM: Asynchronous suspend and resume of devices
In-Reply-To: <200908262217.19609.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908271637480.25639-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Rafael J. Wysocki wrote:

> Hi,
> 
> The following patches introduce a mechanism allowing us to execute device
> drivers' suspend and resume callbacks asynchronously during system sleep
> transitions, such as suspend to RAM.
> 
> The idea is explained in the changelogs of the first two patches.
> 
> Comments welcome.

I've been terribly busy and haven't had a chance to look at this.  The
earlier version seemed to have a bunch of mutual-exclusion issues; are
they resolved now?  There were also some problems involving unsafe
iteration over the dpm_list -- remember that devices can be
unregistered at any time, not just while they are suspending or
resuming.

When a device finishes, instead of having the async thread look for 
another device to work on, I think it would be better to have the 
thread check the dependents of the current device.  Those which are 
now ready can be added to a "device-ready" list, which is used to 
direct the actions of new async threads.

Alan Stern

