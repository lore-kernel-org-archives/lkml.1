Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbXIMOf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbXIMOf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbXIMOft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:35:49 -0400
Received: from rtr.ca ([76.10.145.34]:1657 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbXIMOfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:35:48 -0400
Message-ID: <46E94AC2.3030607@rtr.ca>
Date: Thu, 13 Sep 2007 10:35:46 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Chuck Ebbert <cebbert@redhat.com>, Niels <zorglub_olsen@hotmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] Problems with USB disk [solved]
References: <Pine.LNX.4.44L0.0709131008360.3619-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709131008360.3619-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Wed, 12 Sep 2007, Mark Lord wrote:
> 
>> Chuck Ebbert wrote:
..
>>> Oh, nice. The usb-storage (SCSI) disk spins itself down and we can't handle that.
>>> Should we be disabling auto-spindown when we connect the device, or be able to
>>> handle this by sending the start command when needed?
>> There's more to this.
>>
>> My Sandisk Cruzer Micro 1GB USB sticks suffer from this regression.
> 
> I seriously doubt that.  Are you claiming that your USB stick spins 
> itself down during a suspend?  And then requires to be spun back up 
> before it will resume proper operation?

No, the machine is not being suspended at all.

What happens is, there's a nice little LED on the Cruzer stick,
that is "lit" when the stick itself is not in a "power suspend" state
(or whatever you USB folks call it).

On 2.6.22, that little LED stays "on" normally, and flickers off/on
when data is being transfered.

The new "USB autosuspend" logic in 2.6.23 now causes that little LED
to turn off after a few seconds of inactivity.

Once that happens, the USB stick is not accessible until after a longish
timeout (~30s I think), followed by a USB reset.  Then it is usable again
until the next inactivity timeout and autosuspend (a few seconds).

Etc.

