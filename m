Return-Path: <linux-kernel-owner+w=401wt.eu-S1755025AbZETORe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbZETORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 10:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZETOR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 10:17:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753526AbZETORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 10:17:25 -0400
Date: Wed, 20 May 2009 10:17:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Mario Limonciello <mario_limonciello@dell.com>,
       <linux-usb@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
In-Reply-To: <200905201429.06113.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0905201010260.2914-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Oliver Neukum wrote:

> > Here's another question: Since there is a udev removal event for the
> > radio device, why not add a udev rule to switch back to HID+bluetooth
> > mode every time that event occurs?
> 
> 1. You'd have two rules doing the same thing (resume & addition)

That's okay.  Inelegant, perhaps, but workable.  Besides, as we see 
below, the new rule would have to do more than the old rule.

> 2. It is unclean, as the removal event doesn't tell you which device to run
> hid2hci on

I'm sure you could figure it out from the sysfs paths.

> 3. The device might really be physically removed

True.  So you'd want to delay for a second or so before trying to do
the switch and check whether the device is still attached.

> 4. You can intentionally run hid2hci to switch back to HID

Does that create the same removal event?  If it does then you wouldd be
in an unfortunate state.  The script would have to check somehow
whether the removal was deliberate or spontaneous.

> PS: Why, oh why don't people use configurations as they were designed?

I can't answer that.  :-)

Alan Stern

