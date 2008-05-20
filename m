Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbYETIk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbYETIk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 04:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYETIkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 04:40:10 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:40328 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYETIkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 04:40:08 -0400
Date: Tue, 20 May 2008 10:39:42 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: 2.6.26-rc1 regression since 2.6.25
Message-ID: <20080520083942.GA5025@ics.muni.cz>
References: <20080519104948.GA4557@ics.muni.cz> <Pine.LNX.4.44L0.0805191126260.15266-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0805191126260.15266-100000@iolanthe.rowland.org>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 20 May 2008 10:39:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 11:47:11AM -0400, Alan Stern wrote:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10630
> 
> Can you attach an equivalent dmesg log for 2.6.25 (with
> CONFIG_USB_DEBUG enabled, of course)?

attached.

> Let me get this straight.  You booted without the dock, and then at 
> this line:
> 
> > [14315425.975807] ACPI: \_SB_.GDCK - docking
> 
> you plugged the computer into the dock, right?

Yup.

> 
> Then apparently here:
> 
> > [14315508.451197] ehci_hcd 0000:00:1a.7: port 4 remote wakeup
> 
> you plugged the USB drive into the dock, but it wasn't detected.  Or
> maybe I've got it backward, the drive was already plugged in when you
> docked the computer, and 14315508.451197 is when you unplugged the
> drive.  Which was it?

More precisly, it was already plugged but the external power of the USB drive 
was switched off and I just switched it on after I had docked. 

> Okay, let's see some more debugging information on this.  Get a usbmon
> trace (see Documentation/usb/usbmon.txt) for bus 3, starting just 
> before you dock the computer.  That will tell us exactly what the 
> dock's USB hub is reporting.

Moreover, I discovered that removing ehci module before I put the machine into
the dock causes the uhci module to discover the USB device. Dmesg traces are
attached.

Do you still need the usbmon traces?

-- 
Luká¹ Hejtmánek
