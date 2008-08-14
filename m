Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYHNWZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYHNWZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYHNWZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:25:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42265 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752113AbYHNWZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:25:33 -0400
Date: Thu, 14 Aug 2008 18:25:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808142343.56505.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808141819470.2148-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008, Oliver Neukum wrote:

> The core problem is that you insist on a rigid bottom-to-top flow of
> autosuspensions. That's good for systems like USB and PCI which
> are trees for PM purposes. It makes no sense for true busses with
> equal members on the bus.

My framework is tree-oriented because it's based on the driver model, 
which uses a tree of devices.

Even on a true bus, the members can't be entirely equal -- one of them 
has to be closer to the CPU than the others are.  If that one member is 
in a low-power state then the CPU can't communicate with anything on 
the bus, unlike when one of the other members is in a low-power state.

(I suppose in theory there could be a situation in which the CPU has
direct communication with a bunch of devices, which can also
communicate among themselves over some other bus.  In such a situation
we would represent the devices as members of separate branches in the
device tree, so that suspending one would have no impact on suspending
the others.  The presence of the interconnecting bus would be ignored.)

Alan Stern

