Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYIBVHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYIBVHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYIBVGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:06:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51415 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754070AbYIBVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:06:54 -0400
Date: Tue, 2 Sep 2008 17:06:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thiago Galesi <thiagogalesi@gmail.com>
cc: Alex Buell <alex.buell@munted.org.uk>, <linux-kernel@vger.kernel.org>,
       Robert Hancock <hancockr@shaw.ca>, Tomas Styblo <tripie@cpan.org>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix - device
 152d:2338
In-Reply-To: <82ecf08e0809021316l68272103q9daff7b12ed90e8b@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809021654330.5583-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Thiago Galesi wrote:

> > However what finally caused the failure was a command (0xAC) which I
> > don't recognize and apparently your drive doesn't recognize either.
> 
> Is this it? dfbb5d80 1845367929 C Bi:6:002:1 0 13 = 55534253 acc90100
> 00000000 00

No, it was this:

dfbb5d80 1845397954 S Bo:6:002:2 -115 31 = 55534243 dac90100 08000000 80000cac 00000000 00000000 01030000 000000

The initial sign of a problem is the -104 error code about five lines 
farther down in the log.

The odd thing is that the device did give an 8-byte response to that 
command (as it was supposed to) but then apparently crashed and didn't 
provide any status.  After that everything failed.

I don't know; maybe it was just a coincidence that the failure occurred 
the first time this command was used.

> Any idea who may be sending this? I mean,  can this be send via a
> simple IOCTL to /dev/sr0 or it is something else?
> Maybe stracing the program would be a good idea.

Maybe.  If you were trying to write a DVD during the test then almost 
certainly the command was sent by an IOCTL like you said.  You could 
probably figure out what the command was supposed to do by looking 
through the source code for the program.

> If I were to place a trace inside a driver, were would it be better?
> sr_mod, sd_mod, usb-storage, cdrom? or somewhere else?

It depends on what you want to trace.  Although in this case it's safe 
to ignore sd_mod since your device uses sr_mod.

Alan Stern

