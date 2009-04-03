Return-Path: <linux-kernel-owner+w=401wt.eu-S932902AbZDCPF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbZDCPF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 11:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764822AbZDCPFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 11:05:09 -0400
Received: from rtr.ca ([76.10.145.34]:35584 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763546AbZDCPFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 11:05:08 -0400
Message-ID: <49D625A0.1030202@rtr.ca>
Date: Fri, 03 Apr 2009 11:05:04 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       tytso@mit.edu, drees76@gmail.com, jesper@krogh.cc,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090401143622.b1885643.akpm@linux-foundation.org> <20090402010044.GA16092@elte.hu> <20090403040649.GF3795@csclub.uwaterloo.ca> <alpine.LFD.2.00.0904022112260.4130@localhost.localdomain> <20090403072507.GO5178@kernel.dk> <20090403142129.GH3795@csclub.uwaterloo.ca>
In-Reply-To: <20090403142129.GH3795@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
>
> Well the system is setup like this:
> 
> Core 2 Quad Q6600 CPU (2.4GHz quad core).
> Asus P5K mainboard (Intel P35 chipset)
> 6GB of ram
> PVR500 dual NTSC tuner pci card
..
> So the behaviour with cfq is:
> Disk light seems to be constantly on if there is any disk activity.  iotop
> can show a total io of maybe 1MB/s and the disk light is on constantly.
..

Lennart,

I wonder if the problem with your system is really a Myth/driver issue?

Curiously, I have a HVR-1600 card here, and when recording analog TV with
it the disk lights are on constantly.  The problem with it turns out to
be mythbackend doing fsync() calls ten times a second.

My other tuner cards don't have this problem.

So perhaps the PVR-500 triggers the same buggy behaviour as the HVR-1600?
To work around it here, I decided to use a preload library that replaces
the frequent fsync() calls with a more moderated behaviour:

   http://rtr.ca/hvr1600/libfsync.tar.gz

Grab that file and try it out.  Instructions are included within.
Report back again and let us know if it makes any difference.

Someday I may try and chase down the exact bug that causes mythbackend
to go fsyncing berserk like that, but for now this workaround is fine.

Cheers
