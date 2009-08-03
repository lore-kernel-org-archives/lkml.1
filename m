Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZHCPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZHCPp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbZHCPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:45:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35446 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754891AbZHCPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:45:27 -0400
Date: Mon, 3 Aug 2009 11:45:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Artur Skawina <art.08.09@gmail.com>
cc: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: reading errors on JMicron JM20337 USB-SATA
In-Reply-To: <4A77035C.5090906@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0908031142180.16208-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Artur Skawina wrote:

> > You are correct except for the term "indefinitely".  The retries _will_
> > stop if you wait long enough.  Unfortunately, because of all the nested
> > retry loops in the SCSI drivers and at the application level, you may
> > have to wait as long as half an hour.
> 
> iirc, i had stalls _way_ longer than that, probably because the reads
> eventually succeeded, only to stall on the next ones.
> 
> > I agree that this should be fixed.  But it is a SCSI issue, not a USB 
> > issue.  You could try bringing it up on the linux-scsi mailing list.
> 
> actually, the number of retries should probably be configurable, but i
> wouldn't lower them by default; losing data because of recoverable errors
> is bad. In this case the bridge may be at fault (by not passing along the
> error), but to make a significant difference you'd have to reduce the number
> of retries to something like zero, maybe one at most, and that's just too
> low for a default. 

As I understand it, the SCSI and block layers conspire to keep retrying
each command until a timeout expires, not until the number of retries 
reaches a limit.

But the situation is complicated, because some kinds of retries reset 
the timer.  And if the application repeats the I/O request then of 
course everything starts over again.

Alan Stern

