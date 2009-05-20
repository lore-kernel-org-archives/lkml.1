Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbZETSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbZETSd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758410AbZETSb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:31:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48909 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758562AbZETSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:31:26 -0400
Date: Wed, 20 May 2009 14:31:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mario Limonciello <mario_limonciello@dell.com>
cc: Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Marcel Holtmann <marcel@holtmann.org>, <linux-acpi@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Explicitly disable BT radio using rfkill interface on
 suspend
In-Reply-To: <4A144347.80303@dell.com>
Message-ID: <Pine.LNX.4.44L0.0905201423130.4044-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 May 2009, Mario Limonciello wrote:

> Hi Alan:
> 
> Alan Stern wrote:
> > On Wed, 20 May 2009, Oliver Neukum wrote:
> >
> >   
> >
> > That's okay.  Inelegant, perhaps, but workable.  Besides, as we see 
> > below, the new rule would have to do more than the old rule.
> >
> >   
> I agree this is a rather inelegant solution. A  new rule would have to
> be added to hid2hci then.  It's much more preferable to be able to fix
> kernel space from mucking up the device.  Is there a way to mark a
> device to /not/ run reset-resume after S3?

	echo 0 >/sys/bus/usb/devices/.../power/persist

This will also prevent reset-resume after hibernation.

> > Does that create the same removal event?  If it does then you wouldd be
> > in an unfortunate state.  The script would have to check somehow
> > whether the removal was deliberate or spontaneous.
> >   
> Yes it does create the same removal event when you switch to HID mode. 
> I don't know of any way that you can calculate if the switch was
> intentional.

You can't.  Instead you have to arrange things so that when the
intentional change was made, it left behind a timestamp indicator.  If
that timestamp if present and not more than a few seconds in the past,
you know the change was intentional.

Alan Stern

