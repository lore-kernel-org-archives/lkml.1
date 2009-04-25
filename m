Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZDYI1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZDYI1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZDYI1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:27:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50654 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZDYI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:27:09 -0400
Date: Sat, 25 Apr 2009 10:26:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: Avi Kivity <avi@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Szabolcs Szakacsits <szaka@ntfs-3g.com>,
       Grant Grundler <grundler@google.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
Message-ID: <20090425082659.GH2428@ucw.cz>
References: <20090412091228.GA29937@elte.hu> <Pine.LNX.4.62.0904121806060.9521@tamago.serverit.net> <20090412162018.6c1507b4@lxorguk.ukuu.org.uk> <49E213AE.4060506@redhat.com> <alpine.LFD.2.00.0904120950050.4583@localhost.localdomain> <49E2DC96.6090407@redhat.com> <alpine.LFD.2.00.0904130747440.4583@localhost.localdomain> <49E45E9C.1020105@redhat.com> <49E46437.5000804@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E46437.5000804@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Well, no one is talking about 64KB granularity for in-core files.  Like 
>> you noticed, Windows uses the mmu page size.  We could keep doing that, 
>> and still have 16KB+ sector sizes.  It just means a RMW if you don't  
>> happen to have the adjoining clean pages in cache.
>>
>> Sure, on a rotating disk that's a disaster, but we're talking SSD here, 
>> so while you're doubling your access time, you're doubling a fairly  
>> small quantity.  The controller would do the same if it exposed smaller 
>> sectors, so there's no huge loss.
>>
>> We still lose on disk storage efficiency, but I'm guessing that a 
>> modern tree with some object files with debug information and a .git 
>> directory it won't be such a great hit.  For more mainstream uses, it 
>> would be negligible.
>
>
> Speaking of RMW...    in one sense, we have to deal with RMW anyway.  
> Upcoming ATA hard drives will be configured with a normal 512b sector  
> API interface, but underlying physical sector size is 1k or 4k.
>
> The disk performs the RMW for us, but we must be aware of physical  
> sector size in order to determine proper alignment of on-disk data, to  
> minimize RMW cycles.

Also... RMW hsa some nasty reliability implications. If we use 1KB
block size ext3 (or something like that), unrelated data may now be
damaged during powerfail. Filesystems can not handle that :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
