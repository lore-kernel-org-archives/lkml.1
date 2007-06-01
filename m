Return-Path: <linux-kernel-owner+w=401wt.eu-S1758044AbXFAHYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbXFAHYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXFAHYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:24:25 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33476 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFAHYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:24:24 -0400
Message-ID: <465FC92C.50608@cosmosbay.com>
Date: Fri, 01 Jun 2007 09:22:20 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk> <465F9BEF.20504@zytor.com> <20070601054120.GI32105@kernel.dk> <465FB3AD.5030807@zytor.com>
In-Reply-To: <465FB3AD.5030807@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Fri, 01 Jun 2007 09:22:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin a écrit :
> Jens Axboe wrote:
>>> I would personally argue that sendfile() blocking on an O_NONBLOCK
>>> desriptor, as opposed to returning EAGAIN, is a bug, and a fairly
>>> serious such.
>> I agree, but it's still a change in behaviour. Even if we consider the
>> app buggy (it is), can we potentially break it?
>>
> 
> It depends on which app it is, of course.  However, I think we have to
> smoke that out the hard way.  I don't think we should retain a bug in
> the kernel just because some unknown app might depend on that bug --
> taking that to the extreme  we could never fix bugs at all...
> 

As I said, this new non blocking feature on the input side (disk), is nice and 
usefull. (For people scared by splice() syscall :) )

Just have to mention it is a change of behavior, and documentation probably 
needs to reflect this change. "Since linux 2.6.23, sendfile() repects 
O_NONBLOCK on in_fd as well"


My man page here says :

ERRORS
        EAGAIN Non-blocking I/O has been selected using O_NONBLOCK and the 
write would block.

        EBADF  The input file was not opened for reading or the output file 
was not opened for writing.

        EFAULT Bad address.

        EINVAL Descriptor is not valid or locked, or an mmap()-like operation 
is not available for in_fd.

        EIO    Unspecified error while reading from in_fd.

        ENOMEM Insufficient memory to read from in_fd.


This implies O_NONBLOCK on the out filedesc, not the input one :)

