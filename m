Return-Path: <linux-kernel-owner+w=401wt.eu-S1750783AbXBKSeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750783AbXBKSeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 13:34:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbXBKSeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 13:34:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:3241 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXBKSeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 13:34:11 -0500
Date: Sun, 11 Feb 2007 12:34:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: libsata doesn't like bus without master
In-reply-to: <fa.3Ti1gtH2JY4DWsqr3J1loC7lcc0@ifi.uio.no>
To: Patrick Ale <patrick.ale@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>
Message-id: <45CF619D.6000704@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.OcrmlkSFqen95BGHXWJdR6KGswQ@ifi.uio.no>
 <fa.mIV6AQH7D5yiY39XNxbu0M2/1Kc@ifi.uio.no>
 <fa.3Ti1gtH2JY4DWsqr3J1loC7lcc0@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Ale wrote:
> On 2/11/07, Robert Hancock <hancockr@shaw.ca> wrote:
>> Patrick Ale wrote:
>> > Something unrelated to the tests I am doing.
>> >
>> > I found out that the libsata driver doesn't really cope or likes the
>> > idea that you might have a controller without a master drive
>> > configured.
>> >
>> > In this case on ATA2 I have a CDROM drive, connected as slave.
>> > ATA: abnormal status 0x7F on port 0x177
>> > ATA: abnormal status 0x7F on port 0x177
>> > ata2.01: ATAPI, max UDMA/66
>> > ata2.01: configured for UDMA/66
>>
>> Having a single drive on the channel configured as slave is not really a
>> legal configuration. (I believe the ATA standards say that it's
>> something that a host controller/driver/OS is allowed to support, but it
>> is not required to.) A single drive should always be set to master (and
>> connected to the end of the cable and not the middle, by the way).
> 
> It is very legal when one of your harddisks blows out and you take it
> out temporarely and have no money for a replacement IMO. But then
> again, this is probably an abnormality.

Then in that case you should set the remaining drive as master. That's 
just the way PATA is. A lot of BIOSes won't even detect a drive that's 
set as slave with no master present.

> But still, it even complains when no drive is attached to a controller
> at all. Since when you buy an add-on PCI card you get 2 connectors
> even when you want to add one harddisk how does one deal with that?

Yeah, that's a better point. It's not really complaining, but we could 
probably have a better way of suppressing that message. I think it's 
largely there so that we can debug issues with drives not being detected 
when they should.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

