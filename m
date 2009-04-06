Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZDFOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZDFOP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZDFOPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 10:15:20 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52963 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752970AbZDFOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 10:15:18 -0400
Date: Mon, 6 Apr 2009 10:15:16 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: Linux 2.6.29
Message-ID: <20090406141516.GM3795@csclub.uwaterloo.ca>
References: <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <x49myaxjrsb.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49myaxjrsb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 06:28:36PM -0400, Jeff Moyer wrote:
> Could you try one more test, please?  Switch back to CFQ and set
> /sys/block/sdX/queue/iosched/slice_idle to 0?

I actually am running cfq at the moment, but with Mark's (I think it
was) preload library to change fsync calls to at most one per 5 seconds
instead of 10 per second.  So far that has certainly made things a lot
better as far as I can tell.  Maybe not as good as anticipatory seemed
to be but certainly better.

I can try your suggestion too.

I set sda-sdd to 0.  I removed the preload library from the mythbackend.

> I'm not sure how the applications you are running write to disk, but if
> they interleave I/O between processes, this could help.  I'm not too
> confident that this will make a difference, though, since CFQ changed to
> time-slice based instead of quantum based before 2.6.18.  Still, it
> would be another data point if you have the time.

Well when recording two shows at once, there will be two processes
streaming to seperate files, and usually there will be two commercial
flagging processes following behind reading those files and doing mysql
updates as they go.

> Thanks in advance!

No problem.  If it solves this bad behaviour, it will be all worth it.

-- 
Len Sorensen
