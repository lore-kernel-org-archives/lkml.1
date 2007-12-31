Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXLaSVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXLaSVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXLaSVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:21:43 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:54742 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbXLaSVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:21:42 -0500
Date: Mon, 31 Dec 2007 12:21:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
In-reply-to: <fa.KbCnGLPlUEYe/Ibajd+hTY7A7Qw@ifi.uio.no>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       dpreed@reed.com, Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <47793318.3090803@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.PuxU73ceCfHAUeWLO4W21Zbrm7A@ifi.uio.no>
 <fa.3IG7z0AfHuLo9eQjn7Gkl/+/lnA@ifi.uio.no>
 <fa.XY5q1SY4QX+yjnE6p8T3kbTt/8I@ifi.uio.no>
 <fa.KEBfnq5vGkAJSEhZSx7+yy+Hdbs@ifi.uio.no>
 <fa.MLKgXLxgzIKzm4bQXjEOqg9oDwU@ifi.uio.no>
 <fa.KbCnGLPlUEYe/Ibajd+hTY7A7Qw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> "You plug in PCI DEBUG card and it overclocks your machine" is bad
>> scenario.. (I don't know if it does... can PCI card emulate ISA timings?)
> 
> Easily. Its a bit more restricted by later spec revisions but it can halt
> your box of a week or two if it wants. Video cards used to pull this
> stunt for marketing benchmark numbers.

The drivers, specifically (the old "don't check if the command FIFO is 
full before writing, just write anyway and if it's full let the whole 
PCI bus stall while the FIFO empties out" trick).

I rather doubt any of those PCI POST debug cards would bother to 
accurately emulate the ISA timings of normal port 0x80 accesses, 
however. Most likely if you plug those in, port 0x80 accesses suddenly 
become lots faster now that the writes are completing on the PCI bus 
before ever hitting ISA/LPC..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

