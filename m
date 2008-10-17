Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYJQRdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYJQRdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbYJQRdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:33:03 -0400
Received: from nat-warsl417-01.aon.at ([195.3.96.119]:36213 "EHLO email.aon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754942AbYJQRdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:33:01 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 13:33:00 EDT
Message-ID: <48F8CC48.5040202@aon.at>
Date: Fri, 17 Oct 2008 19:32:56 +0200
From: Wolfgang Beiter <w.beiter@aon.at>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Lior Dotan <liodot@gmail.com>
CC: Wolfgang Beiter <w.beiter@aon.at>,
       =?ISO-8859-15?Q?G=FCnter_Gebhard?= =?ISO-8859-15?Q?t?= 
	<g.gebhardt@meilhaus.de>
Subject: Staging: Fixes for me4000 pci data collection driver
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear linux team,

try to give some contribution on merging me4000.c driver into linux 
kernel. Please be kind on reading mail, as Im not skilled in
English conversation.



|TODO:


|> 	- checkpatch.pl cleanups


|> 	- sparse cleanups


|> 	- possible /proc interaction cleanups


|> 	- more info needed for Kconfig entry
according to the hardware vendor, several I/O cards (me4000 family) 
are supported by the "me4000" driver.
°) ME-4610 alias ME-JekyII: low cost 16 bit A/D converter.
                             16channels,500 kSsamples/s (about 400 US$)
°) ME-46xx alias ME-FoXX:   several flavours with additional I/O
                             (e.g. 16 bit D/A, isolated inputs ...)
                             (about 1000 to 2000 US$)
Please, for spezific information about the hardware (ME-4610, ME-46xx)
take a look at the vendors web presentation as an English edition is
also offered.
The hardware is up to date (ME-46xx are available also as PCI express).
Applications are: Analog signal aquisition (e.g. sound, acoustic...)
                   Data Logging (temperature, preasure, position ...)
                   Signal Analysis (Digital Oszilloskop, FFT ...)
                   Real Time Applications.
Hardware vendor:  meilhaus
Linux Driver support for customer: meilhaus/sourceforge.net
                                    (support broken since middle 2006)



|> 	- real device id?
File "me4000.h" defines a section "PCI vendor and device ID" for
different me4000 hardware. Maybe thats what you need ?



|> 	- module parameter cleanup



|erm.  Exactly what is the userspace interface which this driver is
|implementing?
Up to now, userspace programs are simple konsole test programs in C.
They are supplied by the "me4000-2.0.7.tar.gz" tarball, downloadable
from www.sourceforge.net/projects/meilhaus.
For each hardware section on the PCI board a simple C testprogram is 
provided. The hardware sections are...
ai... analog input (testing the A/D converter, data written to
       console or file).
ao... analog output (testing the D/A converter if available on PCI
       board).
dio... digital I/O (reading/writing to one of the 4 8Bit ports)
ext_int... extern interrupt (a signal transition e.g. 0V to 5V on a
            dedicated PIN will cause text output on console).
cnt... counter (counting signal transitions on a didcated PIN)

All me4000 testprograms uses System Calls me4000.c implements.
fd = open(me4000-device-node,...)), read(fd,...), write(fd,...)
                                    ioctl(fd,...), close(fd).
device-nodes are created by the "rc.me4000" bash script.

"me4000-2.0.7.tar.gz" provides also a C library, that customizes
the sys Calls to a more proper API for software application developers.
The API is documented in "meilhaus electronic handbook", downloadable
on the vendors web site.
Id never used the library, want to keep thinks easy as possible.
(Im no C nor linux kernel specialist).

The latest patch tested successfully is 
"add-me4000-pci-data-collection-driver.patch" applied to the
"2.6.25-rc6" linux kernel and running on a ME4610 PCI card installed 
on my computer. (analog output not tested, not supported by ME4610).


So, please feel free to send me another patch for testing purpose.



Best regards,
Wolfgang Beiter, Austria.





