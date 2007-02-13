Return-Path: <linux-kernel-owner+w=401wt.eu-S1751219AbXBMJea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbXBMJea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXBMJea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:34:30 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:48448 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbXBMJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:34:29 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Tue, 13 Feb 2007 10:34:22 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <200702121856.29729.fink@mpe.mpg.de> <20070212190835.20f9b92f@localhost.localdomain>
In-Reply-To: <20070212190835.20f9b92f@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702131034.22639.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Februar 2007 20:08 schrieben Sie:
> On Mon, 12 Feb 2007 18:56:29 +0100
> "Martin A. Fink" <fink@mpe.mpg.de> wrote:
> 
> > I have to store big amounts of data coming from 2 digital cameras to disk. 
> > Thus I have to write blocks of around 1 MB at 30 to 50 frames per second 
for 
> > a long period of time. So it is important for me that the harddisk drive 
is 
> > reliable in the sense of "if it is capable of 50 MB/s then it should 
operate 
> > at this speed. Constantly."
> 
> Hard disks don't do this. They support operations/second based upon
> physical and rotational latency constraints, vibration levels, mechanism,
> internal layout policy and the need to do housekeeping. 

Well they do. The Flash disk I have (SATA-I) is capable of 48 MB/s and this 
value is reached over the whole disk size by windows as well as by FreeBSD. 
See my test results in the first thread.
My Seagate Barracuda Harddisk drive (SATA-II) starts with 76 MB/s and 
decreases linearly to 35 MB/s due to the fact that it has to write to a 
rotating disk. But on a flash disk there is nothing rotating...

So where is the difference between SATA-I and SATA-II ?
And why is FreeBSD able to write with constant rates (the complete 25 GB, all 
with 48+/-0.1 MB/s) but Linux 2.6.18 not ?

> 
> If you have an ATA7 drive with suitable firmware sets you can talk to it
> directly via the SG_IO interface and use the streaming feature set which
> is quite different to filesystem type operations and lets you ask the
> drive to do this sort of stuff - if you can find any general PC firmware
> ones that support it anyway.
> 
> I'm not sure you'll get 50MB/sec sustained to work although you might
> with a good current drive used for nothing else, a linear stream of data
> (no seeking and file system overhead), and a non PCI controller (PCI
> Express, host chipset bus etc). 

With a dedicated (rotating) SATA II device, using the first 70% of disk space 
no problem -- tested ! With a SATA-I device only a problem with Linux 2.6.18
> 
> If you are using a file system then the more you fsync the more I'd
> expect you to see stalling as you keep draining whats effectively an 8MB
> plus pipeline on a modern drive precisely because fsync does "hitting
> disk" guarantees. You also want to be sure you are not journalling data.

That is true. Thus i do the sync only after every 1GB of written data. That is 
not to often in my eyes...
Journaling of data: you are right, ext2 performs better than ext3.


Martin
> 
> Alan
> 
> 
> 

-- 
Dipl. Physiker
Martin Anton Fink
Max Planck Institute for extraterrestrial Physics
Giessenbachstrasse
85741 Garching
Germany
Tel. +49-(0)89-30000-3645
Fax. +49-(0)89-30000-3569
