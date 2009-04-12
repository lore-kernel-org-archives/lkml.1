Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbZDLBSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbZDLBSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 21:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZDLBRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 21:17:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:47183 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987AbZDLBRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 21:17:53 -0400
Date: Sat, 11 Apr 2009 18:15:36 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Grant Grundler <grundler@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Implementing NVMHCI...
In-Reply-To: <20090412002527.631a5a89@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0904111810360.28893@asgard.lang.hm>
References: <49E0D47B.9070205@garzik.org> <20090411203246.513a0892@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0904111250370.4583@localhost.localdomain> <da824cf30904111449y5cb7c178ldf5291506ad6b393@mail.gmail.com> <20090412002527.631a5a89@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009, Alan Cox wrote:

>> We've abstract the DMA mapping/SG list handling enough that the
>> block size should make no more difference than it does for the
>> MTU size of a network.
>
> You need to start managing groups of pages in the vm and keeping them
> together and writing them out together and paging them together even if
> one of them is dirty and the other isn't. You have to deal with cases
> where a process forks and the two pages are dirtied one in each but still
> have to be written together.

gaining this sort of ability would not be a bad thing. with current 
hardware (SSDs and raid arrays) you can very easily be in a situation 
where it's much cheaper to deal with a group of related pages as one group 
rather than processing them individually. this is just an extention of the 
same issue.

David Lang

> Alternatively you go for read-modify-write (nasty performance hit
> especially for RAID or a log structured fs).
>
> Yes you can do it but it sure won't be pretty with a conventional fs.
> Some of the log structured file systems have no problems with this and
> some kinds of journalling can help but for a typical block file system
> it'll suck.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
