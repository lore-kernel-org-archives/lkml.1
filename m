Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYIWSbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYIWSbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbYIWSa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:30:57 -0400
Received: from [198.145.64.141] ([198.145.64.141]:43868 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751545AbYIWSa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:30:57 -0400
X-Greylist: delayed 975 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 14:30:56 EDT
Date: Tue, 23 Sep 2008 11:07:09 -0700
From: Greg KH <greg@kroah.com>
To: cihan =?iso-8859-1?B?9np0/HJr?= <cihanozturk@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB driver problem with external hub
Message-ID: <20080923180709.GB8661@kroah.com>
References: <684433.70774.qm@web37502.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <684433.70774.qm@web37502.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 04:35:03PM -0700, cihan öztürk wrote:
> I am working on a device driver for providing connectivity to a Silabs
> F340 board through USB. All the required software, including firmware
> on the device side, USB device driver and user level libraries as well
> as the application, are implemented. The system operates fine when
> experimental communication is considered, in which dummy data is
> simply sent and received betweeen the host and the device at Full
> speed. The trouble comes when a USB external hub is used as a gateway
> between the device and the host instead of directly connecting the USB
> cable from device to the USB port of the PC. The kernel log states
> that the transfer of urb failed due to -EPROTO(-71), which is defined
> as protocol error. I found in some resources that this error can be a
> result of (a) bitstuff error, or (b) no response packet received
> within the prescribed bus turn-around time, or (c)hardware problems
> such as bad devices (including firmware) or cables.
> The hub is a Digitus product with 7 ports and works fine with other
> USB devices such as the mouse on the same platform.
> My kernel version is 2.6.18.

Is this because you are using a USB 2.0 hub, connected via EHCI and your
device is a 1.1 speed device?  If so, this is a known issue with older
kernel versions, and has partially been fixed in newer kernel releases.

Please try 2.6.26 and let us know if that solves the issue.

Or just use a 1.1 hub, that should also work.

thanks,

greg k-h
