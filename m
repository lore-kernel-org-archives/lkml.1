Return-Path: <linux-kernel-owner+w=401wt.eu-S965108AbXBTEhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108AbXBTEhO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 23:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932836AbXBTEhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 23:37:14 -0500
Received: from customer-domains.icp-qv1-irony7.iinet.net.au ([203.59.1.128]:36476
	"EHLO customer-domains.icp-qv1-irony7.iinet.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbXBTEhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 23:37:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAH4J2kV8qGxQdGdsb2JhbACibQEBAQ
X-IronPort-AV: i="4.14,193,1170604800"; 
   d="scan'208"; a="503139220:sNHT17039476"
From: "Marc Marais" <marcm@liquid-nexus.net>
To: Tejun Heo <htejun@gmail.com>, auxsvr@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: ata command timeout
Date: Tue, 20 Feb 2007 12:37:08 +0800
Message-Id: <20070220043029.M46338@liquid-nexus.net>
In-Reply-To: <45DA7416.4040101@gmail.com>
References: <200702192119.50954.auxsvr@gmail.com> <45DA7416.4040101@gmail.com>
X-Mailer: Open WebMail 2.51 20050627
X-OriginatingIP: 159.99.34.18 (marc)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 13:07:50 +0900, Tejun Heo wrote
> auxsvr@gmail.com wrote:
> > Hello,
> > 
> > I have been running 2.6.18 for two months and the last couple of days these 
> > error messages have appeared in my logs 
> > (sata_promise kernel module, sda:SATA sdb:PATA disks):
> > 
> >                                                ata1: command timeout
> > Feb 17 22:23:14 linux kernel: ata1: no sense translation for status: 0x40
> > Feb 17 22:23:14 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
> > SK/ASC/ASCQ 0xb/00/00
> > Feb 17 22:23:14 linux kernel: ata1: status=0x40 { DriveReady }
> > Feb 17 22:23:14 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
> > Feb 17 22:23:14 linux kernel: sda: Current: sense key: Aborted Command
> > Feb 17 22:23:14 linux kernel:     Additional sense: No additional sense 
> > information
> > Feb 17 22:23:14 linux kernel: end_request: I/O error, dev sda, sector 
> > 145179585
> > Feb 17 22:23:14 linux kernel: Buffer I/O error on device sda2, logical block 
> > 2787300
> > Feb 17 22:23:14 linux kernel: lost page write due to I/O error on sda2
> > 
> > and 
> > 
> >                                                ata1: command timeout
> > Feb 19 20:39:31 linux kernel: ata1: no sense translation for status: 0x40
> > Feb 19 20:39:31 linux kernel: ata1: translated ATA stat/err 0x40/00 to SCSI 
> > SK/ASC/ASCQ 0xb/00/00
> > Feb 19 20:39:31 linux kernel: ata1: status=0x40 { DriveReady }
> > Feb 19 20:39:31 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x08000002
> > Feb 19 20:39:31 linux kernel: sda: Current: sense key: Aborted Command
> > Feb 19 20:39:31 linux kernel:     Additional sense: No additional sense 
> > information
> > Feb 19 20:39:31 linux kernel: end_request: I/O error, dev sda, sector 89553479
> > 
> > without any other ill-effects that I know of(I did smart tests on the drive; 
> > all passed successfully).
> > I have read that hddtemp may be the cause of this (I am running version 0.3) 
> > so is there any reason
> > to worry and prepare for a HDD replacement?
> 
> Not really.  If the problem occurs very infrequently, you don't need 
> to worry about it too much.  Command timeouts do occur on otherwise healthy
> systems from time to time.
> 
> -- 
> tejun
> -

I'm experiencing the exact same problem with my setup also with sata_promise.
I have posted to the linux-ide list but it wasn't really acknowledged as a
problem in the driver. Are these command timeouts? The log entry doesn't seem
to say that - just an error with 'DriveReady' and command aborted. I would
think some kind of retry should be performed (and if it is then logged too).

The errors may be benign but the problem is when using software raid (md
driver) that this error may cause a degraded array and worse a damaged array
should a read error like this occur when an array is already degraded.

The question is what happens after the error is reported, is the operation
retried? In my situation the md layer receives the error and recovers by
taking the data from another drive in the array. 

The fact that you are also experiencing this means it might be an issue that
needs further investigation in my opinion.



Regards,
Marc

--
