Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCZMuI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCZMuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:50:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZCZMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:49:55 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:17998 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZCZMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:49:54 -0400
MIME-Version: 1.0
In-Reply-To: <49CB1F90.3090501@garzik.org>
References: <20090324093245.GA22483@elte.hu> <20090325215016.GP32307@mit.edu>
	 <20090326021034.GA26559@srcf.ucam.org>
	 <f73f7ab80903251944s581166bbk31c26db50750814a@mail.gmail.com>
	 <f73f7ab80903251946u593216eejb75d77c54fc8bdf@mail.gmail.com>
	 <49CAEDA7.1080902@garzik.org>
	 <f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>
	 <alpine.LFD.2.00.0903252017100.3032@localhost.localdomain>
	 <f73f7ab80903252158o1d722068j117b4e9933f67589@mail.gmail.com>
	 <49CB1F90.3090501@garzik.org>
Date: Thu, 26 Mar 2009 08:49:52 -0400
Message-ID: <f73f7ab80903260549w1619d3a9h588001383026febf@mail.gmail.com>
Subject: Re: Linux 2.6.29
From: Kyle Moffett <kyle@moffetthome.net>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 2:24 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Kyle Moffett wrote:
>> Really, I think virtually all of the database programs would be
>> perfectly happy with an "fsbarrier(fd, flags)" syscall, where if "fd"
>> points to a regular file or directory then it instructs the underlying
>> filesystem to do whatever internal barrier it supports, and if not
>> just fail with -ENOTSUPP (so you can fall back to fdatasync(), etc).
>> Perhaps "flags" would allow a "data" or "metadata" barrier, but if not
>> it's not a big issue.
>
> If you want a per-fd barrier call, there is always sync_file_range(2)

The issue is that sync_file_range doesn't seem to be documented to
have any inter-file barrier semantics.  Even then, from the manpage it
doesn't look like
write(fd)+sync_file_range(fd,SYNC_FILE_RANGE_WRITE)+write(fd) would
actually prevent the second write from occurring before the first has
actually hit disk (assuming both are within the specified range).

Cheers,
Kyle Moffett
