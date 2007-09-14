Return-Path: <linux-kernel-owner+w=401wt.eu-S1758402AbXINTIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbXINTIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXINTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:07:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49960 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXINTHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:07:48 -0400
Message-ID: <46EADC02.9070409@garzik.org>
Date: Fri, 14 Sep 2007 15:07:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Distributed storage. Move away from char device ioctls.
References: <20070914185429.GA9439@2ka.mipt.ru>
In-Reply-To: <20070914185429.GA9439@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Hi.
> 
> I'm pleased to announce fourth release of the distributed storage
> subsystem, which allows to form a storage on top of remote and local
> nodes, which in turn can be exported to another storage as a node to
> form tree-like storages.
> 
> This release includes new configuration interface (kernel connector over
> netlink socket) and number of fixes of various bugs found during move 
> to it (in error path).
> 
> Further TODO list includes:
> * implement optional saving of mirroring/linear information on the remote
> 	nodes (simple)
> * new redundancy algorithm (complex)
> * some thoughts about distributed filesystem tightly connected to DST
> 	(far-far planes so far)
> 
> Homepage:
> http://tservice.net.ru/~s0mbre/old/?section=projects&item=dst
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

My thoughts.  But first a disclaimer:   Perhaps you will recall me as 
one of the people who really reads all your patches, and examines your 
code and proposals closely.  So, with that in mind...

I question the value of distributed block services (DBS), whether its 
your version or the others out there.  DBS are not very useful, because 
it still relies on a useful filesystem sitting on top of the DBS.  It 
devolves into one of two cases:  (1) multi-path much like today's SCSI, 
with distributed filesystem arbitrarion to ensure coherency, or (2) the 
filesystem running on top of the DBS is on a single host, and thus, a 
single point of failure (SPOF).

It is quite logical to extend the concepts of RAID across the network, 
but ultimately you are still bound by the inflexibility and simplicity 
of the block device.

In contrast, a distributed filesystem offers far more scalability, 
eliminates single points of failure, and offers more room for 
optimization and redundancy across the cluster.

A distributed filesystem is also much more complex, which is why 
distributed block devices are so appealing :)

With a redundant, distributed filesystem, you simply do not need any 
complexity at all at the block device level.  You don't even need RAID.

It is my hope that you will put your skills towards a distributed 
filesystem :)  Of the current solutions, GFS (currently in kernel) 
scales poorly, and NFS v4.1 is amazingly bloated and overly complex.

I've been waiting for years for a smart person to come along and write a 
POSIX-only distributed filesystem.

	Jeff



