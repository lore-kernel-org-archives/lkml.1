Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbZFPSu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbZFPSu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbZFPSur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:50:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34751 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752338AbZFPSuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:50:46 -0400
Date: Tue, 16 Jun 2009 14:50:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Meyer <thomas@m3y3r.de>
cc: Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
In-Reply-To: <1245174438.9269.5.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.0906161429060.5125-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Thomas Meyer wrote:

> Yes. These patches make usbmon stop abending.
> 
> Successful suspend -> stay in S3 -> resume cylce:

Unfortunately this log is uninterpretable, thanks largely to the two 
mass-storage devices at addresses 9 and 10.  I can't tell what they
are because they don't appear to be listed in the dmesg log you
posted.

The device at address 10 isn't working at all.  It apparently has 4
LUNs but it replies to all commands for all LUNs with an error code
saying that the LUN isn't supported.

The device at address 9 is working, but its I/O clutters up the log.

There's also something at address 4; perhaps an HID device, I can't
tell.

Can you run the test again, this time with no extraneous USB devices 
plugged in?  (That includes hubs.)  And before starting the test, 
collect the contents of /sys/kernel/debug/usb/devices (you'll probably 
have to mount /sys/kernel/debug first).

Alan Stern

