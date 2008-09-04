Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYIDODr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYIDODr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 10:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYIDODi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 10:03:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45659 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751590AbYIDODi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 10:03:38 -0400
Date: Thu, 4 Sep 2008 10:03:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thiago Galesi <thiagogalesi@gmail.com>
cc: Alex Buell <alex.buell@munted.org.uk>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Tomas Styblo <tripie@cpan.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <82ecf08e0809040509v323a3065h68a2e72dc86f23ac@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809040958370.2474-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Thiago Galesi wrote:

> Ok, I looked into this a little bit further...
> 
> K3B provides an interesting log:
> 
> first, this is repeated 3 times:
> 
> (K3bDevice::ScsiCommand) failed:
>                            command:    MODE SELECT (55)
>                            errorcode:  70
>                            sense key:  ILLEGAL REQUEST (5)
>                            asc:        26
>                            ascq:       0
> 
> then it shows:
> 
> (K3bDevice::ScsiCommand) failed:
>                            command:    GET PERFORMANCE (ac)
>                            errorcode:  0
>                            sense key:  NO SENSE (2)
>                            asc:        0
>                            ascq:       0
> (K3bDevice::Device) /dev/scd0: GET PERFORMANCE length det failed.
> 
> And then all commands from then on fail
> 
> strace indicate this is sent via SG_IO IOCTL (unfortunatelly, strace
> doen't show the contents in the ioctl)
> 
> I don't know if the device is supposed to stop working when receiving
> an unkown command (like it is apparently doing), also because
> apparently cdrecord doesn't send this command but fails anyway

Who would ever design a device that was supposed to stop working when 
it received an unknown command?  Obviously there's a bug either in the 
device or in the JMicron adapter.

What commands does cdrecord send and where does it fail?

Oh yes, one other thing...  Have you tried hooking this drive directly 
to an IDE cable (avoiding the USB-ATA adapter) to see if it works okay 
in that environment?  If it does then you know where the bug is.

Alan Stern

