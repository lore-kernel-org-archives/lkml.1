Return-Path: <linux-kernel-owner+w=401wt.eu-S1758652AbXHBQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758652AbXHBQOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXHBQO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:14:27 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:26110 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbXHBQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:14:26 -0400
Date: Thu, 02 Aug 2007 10:14:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: serial flow control appears broken
In-reply-to: <46B1F0CB.9060106@rtr.ca>
To: Mark Lord <lkml@rtr.ca>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Message-id: <46B202DE.5000709@shaw.ca>
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
 <46B1F0CB.9060106@rtr.ca>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I don't believe the speed of the machine has much to do with it,
> as IDE PIO is always at pretty much the same speed (or slower)
> regardless of the CPU speed.
> 
> Best case is about .120 usec per 16-bit word, but that doesn't often pan 
> out
> in practice.  More typical is something closer to 1 usec per 16-bit word.
> 
> So, for multcount=16 (very common), best case is 16 * 256 * .120 = 491 
> usec,
> plus extra overhead for reading the IDE status register (another usec or 
> so),
> and other stuff.  Figure maybe 500usec total per interrupt for multcount=16
> in the best case, or 4000usec in the worst case.
> 
> At 115200bps, we get a byte every 86 usec or so.  Assuming the UART FIFO
> is set to interrupt (warn) us at 12/16 full, we have 4*86 = 344 usec to
> respond and de-assert RTS.  Less than that in practice.
> 
> Conclusion:  using IDE multisector PIO is not a good idea with high speed
> serial transfers happening, since we cannot respond quickly enough.
> 
> It might be possible to set the buffer underrun threshold lower in the 
> UART (?).
> 
> All that said, I doubt that his system is using IDE PIO in the first place.
> Dunno how long IDE DMA interrupts take, but it's probably in the 20-50 
> usec range.

I think that PIO transfers only have to be done with interrupts disabled 
on really old, evil controllers (without unmask set). I don't think 
libata ever disables interrupts during transfers(?)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

