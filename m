Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbZDNMWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbZDNMWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZDNMWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:22:12 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45327 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZDNMWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:22:10 -0400
Message-ID: <49E47FD2.3010705@garzik.org>
Date: Tue, 14 Apr 2009 08:21:38 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com> <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <49E45E9C.1020105@redhat.com> <49E46437.5000804@garzik.org> <49E46779.1040106@redhat.com> <49E47744.3040103@garzik.org> <49E47CD0.3090008@redhat.com>
In-Reply-To: <49E47CD0.3090008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeff Garzik wrote:
>>>> (c) export information indicating the true sector size, in a manner 
>>>> similar to how the ATA driver passes that info to userland 
>>>> partitioning tools.
>>>
>>> Eventually we'll want to allow filesystems to make use of the native 
>>> sector size.
>>
>> At the kernel level, you mean?
>>
> 
> Yes.  You'll want to align extents and I/O requests on that boundary.

Sure.  And RAID today presents these issues to the filesystem...

man mke2fs(8), and look at extended options 'stride' and 'stripe-width'. 
  It includes mention of RMW issues.


>> But if you are talking about filesystems directly supporting sector 
>> sizes >4kb, well, I'll let Linus and others settle that debate :)  I 
>> will just write the driver once the dust settles...
> 
> IMO drivers should expose whatever sector size the device have, 
> filesystems should expose their block size, and the block layer should 
> correct any impedance mismatches by doing RMW.
> 
> Unfortunately, sector size > fs block size means a lot of pointless 
> locking for the RMW, so if large sector sizes take off, we'll have to 
> adjust filesystems to use larger block sizes.

Don't forget the case where the device does RMW for you, and does not 
permit direct access to physical sector size (all operations are in 
terms of logical sector size).

	Jeff



