Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbZDBV4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbZDBV4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZDBV43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:56:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47614 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363AbZDBV42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:56:28 -0400
Message-ID: <49D5347A.8030403@garzik.org>
Date: Thu, 02 Apr 2009 17:56:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: David Rees <drees76@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> 	<20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> 	<20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> 	<20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> 	<20090402110532.GA5132@aniel> <20090402090912.cac200bb.akpm@linux-foundation.org> <72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
In-Reply-To: <72dbd3150904020933y515c7185p5726323c430c339b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rees wrote:
> Either way - forcing the data to be synced to disk a couple times
> every second is a hack and causes fragmentation in filesystems without
> delayed allocation.  Fragmentation really goes up if you are recording
> multiple shows at once.

Check out posix_fallocate(3).  Not appropriate for every situation, 
might eat additional disk bandwidth...

But if you are looking to combat fragmentation, pre-allocation (manual 
or kernel-assisted) is a relevant technique.  Plus, overwriting existing 
data blocks is a LOT cheaper than appending to a file.  fsync's more 
quickly to disk, too.

	Jeff


