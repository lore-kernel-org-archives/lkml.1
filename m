Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbXHBQlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbXHBQlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXHBQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:41:27 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:28244 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbXHBQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:41:26 -0400
Date: Thu, 02 Aug 2007 10:40:20 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: serial flow control appears broken
In-reply-to: <46B20662.6080606@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Message-id: <46B208F4.6090901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
 <46A84B4A.6070902@shaw.ca> <46A8C6F1.4080309@howardsilvan.com>
 <Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
 <46AA2748.80703@howardsilvan.com>
 <Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
 <46AA3801.7090204@shaw.ca> <20070728092842.GC26443@flint.arm.linux.org.uk>
 <Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl>
 <46B1F0CB.9060106@rtr.ca> <46B202DE.5000709@shaw.ca> <46B20662.6080606@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>> I think that PIO transfers only have to be done with interrupts 
>> disabled on really old, evil controllers (without unmask set). I don't 
>> think libata ever disables interrupts during transfers(?)
> 
> That's what "hdparm -u1" (or -u0) controls.
> 
> But it doesn't matter a whit here.  The problem is that the IDE interrupt
> handling can take a long time, regardless of whether it unmasks IRQs or 
> not.
> And if that IDE interrupt interrupts a serial interrupt, then the serial
> stuff won't get handled until the IDE stuff completes.  Thus the problem.
> 
> The "fix" could be to have the serial IRQ handler never unmask interrupts,
> but that's a bit unsociable to others.  The IDE stuff really needs to not
> do so much during the actual IRQ handler.
> 
> Ingo's RT patches would probably fix all of this.

libata also doesn't do the actual PIO transfer from the interrupt 
handler like old IDE does, either, and it only disables interrupts for 
the transfer if it's transferring to/from high memory..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

