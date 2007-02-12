Return-Path: <linux-kernel-owner+w=401wt.eu-S964831AbXBLLUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbXBLLUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964837AbXBLLUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:20:23 -0500
Received: from tag.witbe.net ([81.88.96.48]:39670 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964831AbXBLLUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:20:23 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Tejun Heo'" <htejun@gmail.com>
Cc: "'Alan'" <alan@lxorguk.ukuu.org.uk>, "'Robert Hancock'" <hancockr@shaw.ca>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: AHCI - remove probing of ata2
Date: Mon, 12 Feb 2007 12:19:24 +0100
Organization: AS2917.net
Message-ID: <00e201c74e97$a982fa70$4b00a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <45CFBA90.4090201@gmail.com>
Thread-Index: AcdOcU1jEWACMYkdRr2x9my3Zst8AwAJVPGw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,

> You have a Maxtor connected to that port, right?  That's caused by 

Waoh, you are using crystal ball ? :) You are right, this is a Maxtor
disk, 250 MB. If you want more details about this disk, I can send you
a complete details.

> firmware bug.  Future kernels will consider that condition as 
> protocol 
> violation and blacklist the drive such that NCQ is not used on it.  I 
> think it can be dangerous on rare corner/error cases but there hasn't 
> been any actual report of problems caused by that, so no need 
> to worry 
> about it too much.  If it bothers you, you can turn NCQ off 
> using sysfs 
> node.  Take a look at FAQ section of http://linux-ata.org

I'm just slightly worried about that, and because all this libata
stuff is quite "new", I prefer to report everything I can see, considering
that I can test patches on this machine if people need me to do so.
So, consider this machine as some kind of playground if you have
some code you want someone to test.
 
> Slightly OT, but it's generally a good idea to use LABELs to access 
> filesystems.  With so many ports and EH dynamics including 
> hotplug, it's 
> much more difficult to keep device names persistent and remember them.

Yes, that's what I should do, but I've never really like that stuff ;(
 
> > So, 2.6.20-rc7 results are :
> >  - ata2 probing still very long and delaying boot a lot,
> 
> That's sil4726's config device acting weird.  When reset as a normal 
> device (not PMP device), sil4726 acts as a normal ATA device which is 
> used to configure how the chip behaves.  Unfortunately, the emulation 
> seems to contain some flaws and cause lots of delays as you've seen. 
> I'm attaching a patch to clear TF before IDENTIFY which fixes similar 
> IDENTIFY failures on buggy ATAPI devices.

OK, will try this tonite (I'm sorry, this is my home comp., and I'm at the
office right now - will tell you tomorrow).
 
> >  - Jmicron PATA still not working, and doesn't even detect 
> the DVD-ROM on
> >    the port.
> 
> This problem is likely to be fixed by clearing TF before IDENTIFY.
> 
> So, please test the attached patch and report the result.

Will do, and will test more if you more that are to be tested !

BTW, maybe OT, but what about setting a list of people willing to test
patches together with their configurations so that they can be send
patches related to their hardware ? That could be useful to people developing
drivers...

Regards,
Paul

