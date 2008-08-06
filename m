Return-Path: <linux-kernel-owner+w=401wt.eu-S1759896AbYHFSu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759896AbYHFSu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755708AbYHFSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:50:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125AbYHFSuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:50:11 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface
	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080805203007.GB27489@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
	 <20080805005132.GA3661@kroah.com>
	 <20080805122328.69a37c1d@lxorguk.ukuu.org.uk>
	 <20080805170307.GB9639@kroah.com>
	 <1217962602.27684.144.camel@localhost.localdomain>
	 <20080805203007.GB27489@kroah.com>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 14:49:57 -0400
Message-Id: <1218048597.27684.276.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 13:30 -0700, Greg KH wrote:
> On Tue, Aug 05, 2008 at 02:56:42PM -0400, Eric Paris wrote:

> > So you are arguing against the defense in depth theory?  LSM should
> > solve it all so why bother?
> 
> No, I am saying I have yet to see a real requirement to justify that
> this code goes into the kernel.

While I try to get someone to talk to me, lets consider even the most
simplistic threat model.  I'm not stating that this is the only threat
that vendors wish to protect against, but I think we can all agree it is
a meaningful threat.  Trying to get the AV vendors to talk about their
products actual uses is like pulling teeth.

This simple thread shows what I believe to be clear and compelling
evidence of the need for an in kernel solution.  Lets just consider that
we are a high input, high output, NFS file server with other OS's
mounting this NFS share RW.

Our goal is to stop, or at least reduce the throughput (I clearly
document and accept the open to read race, and until we get a working
revoke I don't see that changing) of malware across the NFS server.
This data will not be attacking the NFS server.  We wish to slow and
hopefully halt the spread of this data with minimal impact to the NFS
server.

Since the NFS server interacts directly with the VFS no purely userspace
solution is possible.  I certainly hope noone tells me we should hook
directly into nfsd and do everything else in userspace   :)

The purpose of this e-mail is not to ask others to find 'the perfect
solution for this one example' but merely to holp move away from the
ideas that this can be done in GLIBC or in LD_PRELOAD.

Maybe my code is all crap, I'm more than willing to accept that, it
wouldn't be the first time, but I do see the open on the NFS server and
I could do "something" with that file on the server.  I can continue to
define lots of other threats that my interface is useful for (even if
Greg dismissed one of them out of hand) but right now I'm trying to get
all of the AV vendors to define what it is they do (and I think we all
know they will claim to do exactly this)

-Eric

