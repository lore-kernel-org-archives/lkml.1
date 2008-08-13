Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYHMO7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYHMO7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbYHMO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:59:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58153 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752491AbYHMO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:59:24 -0400
Date: Wed, 13 Aug 2008 10:59:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@hansenpartnership.com>, <teheo@novell.com>
Subject: Re: Power management for SCSI
In-Reply-To: <200808131647.43989.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808131051330.2455-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Oliver Neukum wrote:

> Very well. I see a basic problem here. For USB it is necessary that child
> devices be suspended before anything higher up in the tree is suspended.
> SATA seems to be able to power down a link while the device is not suspended.

Is the USB transport unique in its requirement that all the child
devices must be suspended before the link can be powered down?  Maybe 
that requirement should be made an explicit property of the transport 
or the transport class.

> In fact in true SCSI busses can be shared. So are we using the correct
> approach?

This is a good question.  Most USB mass-storage devices do not act as a
true SCSI bus, but I believe there are a few non-standard ones that do
-- the USB device really contains a SCSI host and arbitrary SCSI
targets can be attached to it.  For the moment, we should be safe
enough using a model in which there are no other initiators on a
USB-type SCSI transport, but it's something to keep in mind.

Alan Stern

