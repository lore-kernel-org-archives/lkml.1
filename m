Return-Path: <linux-kernel-owner+w=401wt.eu-S1752940AbYKLMgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbYKLMgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYKLMga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:36:30 -0500
Received: from ms01.sssup.it ([193.205.80.99]:48051 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751786AbYKLMga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:36:30 -0500
Date: Wed, 12 Nov 2008 13:38:49 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       paolo.valente@unimore.it,
       Linux Containers <containers@lists.linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/3] BFQ I/O Scheduler (second take)
Message-ID: <20081112123849.GA14817@gandalf.sssup.it>
References: <20081111125148.GD9508@gandalf.sssup.it> <491A43E0.2080109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491A43E0.2080109@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Li Zefan <lizf@cn.fujitsu.com>
> Date: Wed, Nov 12, 2008 10:48:00AM +0800
>
> CC: Linux Containers <containers@lists.linux-foundation.org>
>     Vivek Goyal <vgoyal@redhat.com>
> 
...
> So this is another cgroup-aware block i/o controller. ;)
> 
> People are sending different proposals for bio controller. A summary
> on this can be found here:
> 	http://marc.info/?l=linux-kernel&m=121798534716673&w=2
> 
> And a new proposal sent by Vivek several days ago:
> 	http://lkml.org/lkml/2008/11/6/227
> 
> And there are some discussions about can we modify the elevator layer
> and create a common layer so we can provide group control for all
> the 4 io schedulers. (in the above mail thread)
> 
> You may share some ideas with us.
> 

  yes, BFQ is another block I/O controller, and the ongoing discussion
is very interesting, as the other patchsets proposed.

BFQ deals with hierarchical scheduling in the same way as the proposed
CFQ extensions do, and it does not handle the I/O traking issue, as we
considered it not belonging directly to the elevator layer.

Talking about what may be interesting from the controller POV, it supports
arbitrary hierarchies (not only two layers) and ioprio classes for cgroups.
It can be easily extended to support any I/O tracking mechanism and
per-device ioprio_class/ioprio (it's just about choosing a sane interface
for that).

The main reasons why we turned BFQ into a cgroup controller were:
  - the algorithm was quite easy to adapt, and in a hierarchical
    context the advantages of using WF2Q+ over RR are more relevant.
  - Being a new scheduler, we had some freedom experimenting with it.
  - Avi asked for it :)

I'd like to stress the fact that the I/O controller thing is _not_ the
main feature of BFQ.  At least at this point of its development, we are
more interested in understanding if the differences it introduces WRT
CFQ (namely, the mixed time-service domain approach, WF2Q+ scheduling,
the feedback on budget lengths, etc.) are of interest or not for the
comminity and/or are worth the effort of a new I/O scheduler.
