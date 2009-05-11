Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZEKNzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZEKNzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbZEKNzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:55:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33730 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZEKNzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:55:01 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-rc deadline scheduler performance regression for iozone over NFS
References: <x49hc0f79k9.fsf@segfault.boston.devel.redhat.com>
	<20090508120119.8c93cfd7.akpm@linux-foundation.org>
	<20090511081415.GL4694@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 11 May 2009 09:53:32 -0400
In-Reply-To: <20090511081415.GL4694@kernel.dk> (Jens Axboe's message of "Mon,
	11 May 2009 10:14:15 +0200")
Message-ID: <x49skjb21b7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Fri, May 08 2009, Andrew Morton wrote:
>> On Thu, 23 Apr 2009 10:01:58 -0400
>> Jeff Moyer <jmoyer@redhat.com> wrote:
>> 
>> > Hi,
>> > 
>> > I've been working on CFQ improvements for interleaved I/Os between
>> > processes, and noticed a regression in performance when using the
>> > deadline I/O scheduler.  The test uses a server configured with a cciss
>> > array and 1Gb/s ethernet.
>> > 
>> > The iozone command line was:
>> >   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w
>> > 
>> > The numbers in the nfsd's row represent the number of nfsd "threads".
>> > These numbers (in MB/s) represent the average of 5 runs.
>> > 
>> >                v2.6.29
>> > 
>> > nfsd's  |   1    |  2   |   4   |   8
>> > --------+---------------+-------+------
>> > deadline| 43207 | 67436 | 96289 | 107590
>> > 
>> >               2.6.30-rc1
>> > 
>> > nfsd's  |   1   |   2   |   4   |   8
>> > --------+---------------+-------+------
>> > deadline| 43732 | 68059 | 76659 | 83231
>> > 
>> >     2.6.30-rc3.block-for-linus
>> > 
>> > nfsd's  |   1   |   2   |   4   |   8
>> > --------+---------------+-------+------
>> > deadline| 46102 | 71151 | 83120 | 82330
>> > 
>> > 
>> > Notice the drop for 4 and 8 threads.  It may be worth noting that the
>> > default number of NFSD threads is 8.
>> > 
>> 
>> I guess we should ask Rafael to add this to the post-2.6.29 regression
>> list.
>
> I agree. It'd be nice to bisect this one down, I'm guessing some mm
> change has caused this writeout regression.

It's not writeout, it's a read test.

Cheers,
Jeff
